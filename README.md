# LesaNet container environment #
* Set docker's default-runtime to 'nvidia' in order to build the image with nvidia runtime
  * i.e insert `"default-runtime": "nvidia",` into `/etc/docker/daemon.json` and restart the daemon `systemctl restart docker`
* Download [checkpoint](https://nihcc.app.box.com/s/vbjermlyqlxee7s6pkbddlfu4mljf58w "download link")
* `docker build --tags=lesanet .`
* `docker run -it --rm lesanet`
* `bash ./run.sh`