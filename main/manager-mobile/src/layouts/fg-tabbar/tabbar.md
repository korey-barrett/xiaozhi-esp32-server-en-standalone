# tabbar Notes

The `tabbar` has `4` variants:

- 0 `No tabbar`, only a single page entry, no `tabbar` shown at the bottom; commonly used for temporary activity pages.
- 1 `Native tabbar`, uses `switchTab` to switch tabs; `tabbar` pages are cached.
  - Advantages: the native built-in tabbar renders first and is cached.
  - Disadvantages: only 2 sets of images can be used to switch between selected and unselected states; changing the color requires replacing images (or using iconfont).
- 2 `Cached custom tabbar`, uses `switchTab` to switch tabs; `tabbar` pages are cached. Uses the third-party UI library's `tabbar` component and hides the native `tabbar`.
  - Advantages: you can freely configure your own `svg icon`, and switching font colors is easy. There is caching. Various fancy animations can be implemented.
  - Disadvantages: the first tap on the tabbar flickers.
- 3 `Uncached custom tabbar`, uses `navigateTo` to switch `tabbar`; `tabbar` pages are not cached. Uses the third-party UI library's `tabbar` component.
  - Advantages: you can freely configure your own svg icon, and switching font colors is easy. Various fancy animations can be implemented.
  - Disadvantages: the first tap on `tabbar` flickers, and there is no caching.


> Note: fancy effects need to be implemented by yourself; this template does not provide them.
