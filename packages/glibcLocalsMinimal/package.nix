{ infuse, glibcLocales }:
infuse glibcLocales {
  __input.allLocales.__assign = false;
  __input.locales.__assign = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];
}
