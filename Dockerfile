ARG ALPINE_VERSION=3.8

FROM library/alpine:${ALPINE_VERSION} as builder

ARG VIM_VERSION=v8.1.0509
RUN apk update
RUN apk add git
RUN git clone https://github.com/vim/vim
RUN apk add \
	alpine-sdk \
	lua5.2-dev \
	ncurses-dev \
	python3-dev
WORKDIR /vim
RUN git checkout ${VIM_VERSION}
RUN ./configure \
	--disable-nls \
	--enable-gui=no \
	--enable-luainterp \
	--enable-multibyte \
	--enable-python3interp=dynamic \
	--prefix=/usr \
	--with-compiledby="Alpine Linux" \
	--with-lua-prefix=/usr/lua5.2 \
	--without-x
RUN make install

WORKDIR /
ADD https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim /root/.vim/autoload/plug.vim
RUN echo -e "call plug#begin()\nPlug 'Valloric/YouCompleteMe'\ncall plug#end()" > /root/.vimrc
RUN vim -c "PlugInstall" -c "qa"


FROM library/alpine:${ALPINE_VERSION} as primary

COPY --from=builder /usr/bin/vim /usr/bin/vim
COPY --from=builder /usr/share/vim/ /usr/share/vim/
COPY --from=builder /root/.vim/ /root/.vim/

RUN apk --update --no-cache add \
lua5.2-dev \
ncurses-dev \
python3-dev

RUN apk --update --no-cache add \
curl \
git \
jq \
screen \
tree \
wget

ADD https://raw.githubusercontent.com/hackenfreude/dotfiles/master/screenrc /root/.screenrc
ADD https://raw.githubusercontent.com/hackenfreude/dotfiles/master/gitconfig /root/.gitconfig
ADD https://raw.githubusercontent.com/hackenfreude/dotfiles/master/vimrc /root/.vimrc

