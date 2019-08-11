# Docker images

The main goal is to create Docker images which can be used
to build and test PHP applications, especially Drupal sites.


## Requirements

* `docker --version` >= `18.09`
* Optional
  * `make --version` >= `GNU Make 4.2.1`


## Usage

1. Run `make` and you will get some help about the targets.
0. Run `make apt-cacher.run` (apt-cacher Docker image isn't part of this project)
0. Run `make build`
0. Wait :-)


## Docker image hierarchy

* ubuntu
  * ${vendor}/phpbrew
    * ${vendor}/php
      * ${vendor}/php-env-base
        * ${vendor}/php-env-dev (COPY --from=${vendor}/nvm and COPY --from=${vendor}/node)
  * ${vendor}/nvm
    * ${vendor}/node


## Version numbering

Each Docker image has a separated version numbering.
The release tag format is: `<image_name_without_vendor>/v\d+\.\d+\.\d+`

Examples:
* `git tag phpbrew/v1.0.0`
* `git tag php/v1.0.0`
* `git tag nvm/v1.0.0`
* `git tag node/v1.0.0`
* `git tag php-env-base/v1.0.0`
* `git tag php-env-dev/v1.0.0`

Current version numbering is far from the best.
The version number of the following Docker images are the same 
as the version number of the software it contains.
* The `phpbrew:1.23.1` Docker image contains _PHPBrew_ 1.23.1. 
  If anything changes in the Docker image but the _PHPBrew_ it self, 
  then you can't indicate that in the version number.
  Maybe we should add the date in _Ymd_ format to the metadata part 
  of the version number.
  These Docker image tags (phpbrew:x.x.x) are created automatically
  if you use the corresponding _make_ target.
* The version numbering of the `php` Docker images is the same as that of `phpbrew`
* The version numbering of the `node` Docker images is the same as that of `phpbrew`
* The version numbering of the `nvm` Docker images is the same as that of `phpbrew`
* The version numbering of the `php-env-base` and `php-env-dev` Docker images are the same,
  but differs from the other ones.
  * `php-env-base:1.x` => `php-env-base:1.0.0` means it contains `PHP 7.1.x`
  * `php-env-base:2.x` => `php-env-base:2.0.0` means it contains `PHP 7.2.x`
  * `php-env-base:3.x` => `php-env-base:3.0.0` means it contains `PHP 7.3.x`
