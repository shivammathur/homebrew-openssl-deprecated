# shivammathur/homebrew-openssl-deprecated

![Build Formula](https://github.com/shivammathur/homebrew-openssl-deprecated/workflows/Dispatch%20build%20bottle/badge.svg)
![License](https://img.shields.io/badge/license-MIT-428f7e.svg?logo=open%20source%20initiative&logoColor=white&labelColor=555555)
![OpenSSL](https://img.shields.io/badge/OpenSSL-1.0.2u-555555.svg?logo=openssl&logoColor=771113&labelColor=white)

> Homebrew tap for openssl@1.0

## Usage

```bash
brew tap shivammathur/openssl-deprecated
brew install openssl@1.0
```

## Link

- If you need to have `openssl@1.0` first in your PATH run:

```bash
echo "export PATH=\"$(brew --prefix openssl@1.0)/bin:\$PATH\"" >> "$HOME/.bash_profile"
source "$HOME/.bash_profile"
```

- For compilers to find `openssl@1.0` you may set:

```bash
export LDFLAGS="-L$(brew --prefix openssl@1.0)/lib"
export CPPFLAGS="-I$(brew --prefix openssl@1.0)/include"
```

- For `pkg-config` to find `openssl@1.0` you may set:

```bash
export PKG_CONFIG_PATH="$(brew --prefix openssl@1.0)/lib/pkgconfig"
```

## License

- The build scripts in this project are licensed under the [MIT license](LICENSE).
- The formula `openssl@1.0.rb` was sourced from [homebrew-core](https://github.com/Homebrew/homebrew-core) tap, and is provided under [BSD-2-Clause License](HOMEBREW_LICENSE).
- The `OpenSSL` builds are licensed under the [OpenSSL and SSLeay licenses](OPENSSL_LICENSE).
