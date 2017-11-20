## What Is This?
This is a Docker image with my set of packages. There is customization of those components and their interrelations. The dotfiles come from [here](https://github.com/hackenfreude/dotfiles). This is meant to feed other images that are purpose-built to specific development scenarios.

## What Do I Need To Know?
* `$ docker run --rm -it hackenfreude/devenv-alpine:latest` will run this.
* `-e GITNAME='<your name>'` and `-e GITMAIL='<your email>'` will update .gitconfig appropriately.
* `-v $PWD:<path>` will volume mount your working directory so you can write code from within the container.
