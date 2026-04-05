Rails.application.routes.draw do
  get "/up", to: proc { [200, { "Content-Type" => "application/json" }, ['{"status":"ok"}']] }

  mount_devise_token_auth_for "User", at: "auth", controllers: { sessions: "auth/sessions", registrations: "auth/registrations" }

  # Public shop pages
  get "/shop/:username", to: lambda { |env|
    request = ActionDispatch::Request.new(env)
    username = request.params[:username]
    mode = request.params[:mode] || "customer"
    
    begin
      shop = Shop.find_by(username: username)
      return [404, { "Content-Type" => "text/html" }, ["Shop not found"]] if shop.nil?
      
      shop_name = shop.name || "Shop"
      
      if mode == "owner"
        html = <<~HTML
          <!DOCTYPE html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Manage #{shop_name}</title><script src="https://cdn.tailwindcss.com"></script></head><body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen p-4"><div class="max-w-md w-full mx-auto"><h1 class="text-2xl font-bold text-gray-800 mb-2">#{shop_name}</h1><p class="text-gray-600 mb-6">Manage your store</p><div class="bg-white p-4 rounded-lg shadow"><h2 class="font-semibold text-lg mb-2">Add Product</h2><form id="add-form" class="space-y-3"><input type="text" id="p_name" placeholder="Name" class="w-full px-3 py-2 border rounded" required><input type="number" id="p_price" placeholder="Price" class="w-full px-3 py-2 border rounded" required><textarea id="p_desc" placeholder="Description" class="w-full px-3 py-2 border rounded"></textarea><input type="number" id="p_stock" placeholder="Stock" value="0" class="w-full px-3 py-2 border rounded"><button type="submit" class="w-full bg-green-600 text-white py-2 rounded">Add</button></form><div id="result" class="mt-3"></div></div></div><script>document.getElementById('add-form').addEventListener('submit', async(e)=>{e.preventDefault();document.getElementById('result').innerHTML='Adding...';try{const r=await fetch('/api/v1/products',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({product:{name:document.getElementById('p_name').value,price:document.getElementById('p_price').value,description:document.getElementById('p_desc').value,stock_quantity:document.getElementById('p_stock').value,shop_id:#{shop.id}}})});document.getElementById('result').innerHTML=r.ok?'Added!':'Failed';}catch(err){document.getElementById('result').innerHTML='Error';}});</script></body></html>
        HTML
      else
        html = <<~HTML
          <!DOCTYPE html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>#{shop_name}</title><script src="https://cdn.tailwindcss.com"></script></head><body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen p-4"><div class="max-w-md w-full mx-auto"><h1 class="text-2xl font-bold text-gray-800 mb-2">#{shop_name}</h1><p class="text-gray-600 mb-4">#{shop.welcome_message || 'Welcome!'}</p><div id="prods">Loading...</div></div><script>fetch('/api/v1/shops/#{shop.id}/products').then(r=>r.json()).then(d=>{const c=document.getElementById('prods');c.innerHTML=d.products&&d.products.length?d.products.map(p=>'<div class="bg-white p-4 rounded-lg shadow"><h3 class="font-semibold">'+p.name+'</h3><p>'+(p.description||'')+'</p><span class="text-indigo-600 font-bold">'+p.price+' ETB</span></div>').join(''):'No products';}).catch(e=>{document.getElementById('prods').innerHTML='Error';});</script></body></html>
        HTML
      end
      
      [200, { "Content-Type" => "text/html" }, [html]]
    rescue => e
      Rails.logger.error "Error: #{e.message}"
      [500, { "Content-Type" => "text/html" }, ["Error: #{e.message}"]]
    end
  }

  # Setup shop page
  get "/setup-shop", to: lambda { |env|
    request = ActionDispatch::Request.new(env)
    user_id = request.params[:user_id]
    html = <<~HTML
      <!DOCTYPE html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Create Shop</title><script src="https://cdn.tailwindcss.com"></script></head><body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen p-4"><div class="max-w-md w-full mx-auto"><h1 class="text-2xl font-bold text-gray-800 mb-2">Create Your Shop</h1><form id="form" class="space-y-4"><input type="text" id="shop_name" placeholder="Shop Name" class="w-full px-4 py-2 border rounded-lg" required><input type="text" id="shop_username" placeholder="Username (e.g. myshop_bot)" class="w-full px-4 py-2 border rounded-lg" required><textarea id="description" placeholder="Welcome Message" class="w-full px-4 py-2 border rounded-lg"></textarea><input type="text" id="bot_token" placeholder="Bot Token from @BotFather" class="w-full px-4 py-2 border rounded-lg" required><button type="submit" class="w-full bg-indigo-600 text-white py-3 rounded-lg">Create</button></form><div id="result" class="mt-4"></div></div><script>document.getElementById('form').addEventListener('submit',async(e)=>{e.preventDefault();document.getElementById('result').innerHTML='Creating...';try{const r=await fetch('/api/v1/shops/setup',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:#{user_id},shop_name:document.getElementById('shop_name').value,shop_username:document.getElementById('shop_username').value,description:document.getElementById('description').value,bot_token:document.getElementById('bot_token').value})});const t=await r.text();document.getElementById('result').innerHTML=r.ok?'Created!':'Error: '+t;if(r.ok&&typeof Telegram!=='undefined'){setTimeout(()=>Telegram.WebApp.close(),2000);}}catch(err){document.getElementById('result').innerHTML='Error: '+err.message;}});</script></body></html>
    HTML
    [200, { "Content-Type" => "text/html" }, [html]]
  }

  # Public API endpoints
  post "/api/v1/shops/setup", to: "public_shop_setup#create"
  get "/api/v1/shops/:shop_id/products", to: lambda { |env|
    request = ActionDispatch::Request.new(env)
    products = Product.where(shop_id: request.params[:shop_id]).order(created_at: :desc)
    json = { products: products.map { |p| { id: p.id, name: p.name, description: p.description, price: p.price, stock_quantity: p.stock_quantity } } }.to_json
    [200, { "Content-Type" => "application/json" }, [json]]
  }

  # API for React Frontend
  namespace :api do
    namespace :v1 do
      get "seller", to: "sellers#show"
      resources :products
      resources :orders, only: [:index, :show, :update]
      resources :shops, only: [:show, :update]
    end
  end

  # Webhooks
  scope :webhooks do
    post 'telegram', to: 'webhooks/telegram#callback'
    post 'shop_bot', to: 'webhooks/shop_bot#callback'
    post 'chapa', to: 'webhooks/chapa#verify'
  end
end