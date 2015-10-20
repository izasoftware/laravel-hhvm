# laravel-hhvm
This is a docker image for Laravel, HHVM, nginx and memcached  
It's my first image, so welcome pull requests  

For laravel this expects the the public dir to be called public (built based on L4)

````bash
docker build -t=ganey/laravel-hhvm .
````

You can then run the image by mapping the laravel root folder to /var/www:  
* -name is the running docker name  
* -v is localdir:dockerdir  
* -P exposes the port 8080 to a random port  
* If you need a different port, specifiy in config or change to `-p local:8080' (lowercase p here)
````bash
docker run --name=hbf -v /e/sites/hotelbonanza-frontend:/var/www -P ganey/laravel-hhvm
````

