# xclip-system-clipboard.yazi

Cloned from https://github.com/orhnk/system-clipboard.yazi to make it work with xclip

## Config

> [!NOTE]
> You need yazi 3.x for this plugin to work.

## Configuration

Copy or install this plugin and add the following keymap to your `manager.prepend_keymap`:

```toml
on = "<C-y>" (or whatever you want)
run = ["plugin xclip-system-clipboard"]
```

> [!Tip]
> If you want to use this plugin with yazi's default yanking behaviour you should use `cx.yanked` instead of `tab.selected` in `init.lua` (See [#1487](https://github.com/sxyazi/yazi/issues/1487))
