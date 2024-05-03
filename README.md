# LFG

> LFG, It Really Whips the Llama's Ass 🦙🦙🦙🦙

![Demo](example.gif)

LFG is a command-line tool that intelligently helps you find the right terminal commands for your tasks. Such sales pitch.

## Why?

Testing the llama3 model. Initially it was made using ollama locally, but changed to use groq due to not needing to have the llama3 model downloaded.

## Installation

```bash
# install pipx
brew install pipx

# add pipx binaries to path
pipx ensurepath

# restart your terminal
# install LFG
pipx install lfg-llama
```

## Usage

This executable is using Groq, that means you need and [API token](https://console.groq.com/keys).

Add the token to your .bashrc/.zshrc and reload your terminal.

```
export GROQ_API_KEY=1337
```

Now you can use the executable

```bash
lfg kill port 3000

# Kill process listening on port 3000
lsof -i :3000 | xargs kill

```

### Development

```bash
pip install --user pipenv
pipenv --python 3.7
pipenv install
```

### TODO

- Add a flag to choose between all the models available by GROQ
- Fix the setup and pyproject file, including github workflow for releasing the package
