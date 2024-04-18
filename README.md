# Vim Dashboard

**Vim Dashboard** is a plugin designed to enhance your Vim startup experience by providing a customizable dashboard upon opening Vim.

![Vim Dashboard Screenshot](screenshot.png)

## Features

- **Customizable Dashboard**: Easily configure your dashboard with widgets to display useful information.
- **Quick Access**: Direct access to recent files, bookmarks, and project directories.
- **Custom Widgets**: Add custom widgets to display any information you find useful.
- **Easy Configuration**: Simple configuration options to tailor the dashboard to your preferences.
- **Minimalistic Design**: A clean and clutter-free interface to keep your focus on what matters.

## Installation

You can install **Vim Dashboard** using your favorite plugin manager. For example, using [Vim-Plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'hunt-s7/vim-dashboard'
```

Reload your `~/.vimrc` and run `:PlugInstall`.

## Usage

Once installed, **Vim Dashboard** will automatically display upon opening Vim. You can customize the dashboard by editing your `~/.vimrc`:

```vim
" Customize dashboard
let g:dashboard_custom_header = 'Welcome to Vim!'
let g:dashboard_custom_footer = ['github.com/your_username/vim-dashboard', 'Customize Me!']
let g:dashboard_default_executive = 'telescope'

" Add custom widgets
let g:dashboard_custom_section = {
      \ 'bookmarks': get(b:, 'dashboard_bookmarks', []),
      \ 'projects': get(b:, 'dashboard_projects', []),
      \ 'history': get(b:, 'dashboard_history', []),
      \ 'overview': get(b:, 'dashboard_overview', []),
      \ }
```

For more information on customization options, refer to the [documentation](docs/).

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue on the [GitHub repository](https://github.com/hunt-s7/vim-dashboard).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
