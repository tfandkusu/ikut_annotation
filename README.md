# iKut annotation

A simple annotation tool for image classification.

# How to run

```sh
flutter pub get
flutter pub run build_runner build
flutter run -d macos
```

# Settings

| File or directory | Explanation　|
| --- | --- |
| label.txt | up to 4 classes labels to edit label. |
| image/ | images for labeling. |
|result.csv | image file names and these labels. |

# How to operate

| Operation | Key |
| --- | --- |
| Select next image | `]` key |
| Select previous image | `[` keys |
| Set label 1 | `Z` key |
| Set label 2 | `X` key |
| Set label 3 | `C` key |
| Set label 4 | `V` key |
| Select 100 images ahead | `P` key |
| Select 100 previous image | `O` key |

# References

[Food 101](https://www.kaggle.com/dansbecker/food-101)
