# dv

Try this application, if you cannot open files from a DICOM formatted CD or DVD with the provided viewer on your computer.

DICOM image viewer, open an image file from a DICOM CD with Datei | Öffnen, uses ImageMagick

It calls the convert command of ImageMagick that has to be in the search path for programs.

This app was made quick and dirty, because a DICOM CD was not readable with the deployed viewer. You can use it as an example, how external apps can be used include their in- and output streams and as a reference, how a raster graphic viewer can be composed with nearly no coding but with Lazarus (www.lazarus-ide.org) in one evening (include finding the idea).

Quick and dirty means for example:
- Not all menu options of the used menu template are used
- No i18n is provided
- components have still their initial names and text or caption value
Nevertheless, it works and can be optimized/extended/beautified at any time and compiled for many systems.

An easy way to add languages and switch them at runtime is shown in the repository karina

## Install ImageMagick on macOS

I used the \*.tar download and instructions being described at https://imagemagick.org/script/download.php for macOS. You have to download it to your home directory and to unpack it there. The other settings are not necessary. If things change in future, it might be necessary to patch it in the source code of the DICOM viewer.
