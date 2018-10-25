# dv
DICOM image viewer, open an image file from a DICOM CD with Datei | Öffnen, uses ImageMagick

It calls the convert command of ImageMagick that has to be in the search path for programs.

This app was made quick and dirty, because a DICOM CD was not readable with the deployed viewer. You can use it as an example, how external apps can be used include their in- and output streams and as a reference, how a raster graphic viewer can be composed with nearly no coding but with Lazarus (www.lazarus-ide.org) in one evening (include finding the idea).

Quick and dirty means for example:
- Not all menu options of the used menu template are used
- No i18n is provided
- components have still their initial names and text or caption value
Nevertheless, it works and can be optimized/extended/beautified at any time and compiled for many systems.

An easy way to add languages and switch them at runtime is shown in the repository karina
