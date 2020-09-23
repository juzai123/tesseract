Docker image for tesseract, using `Release Builds for Mass Production` section in [tesseract installation doc](https://tesseract-ocr.github.io/tessdoc/Compiling-%E2%80%93-GitInstallation.html)

OCR engine is [Best (most accurate) trained LSTM models.](https://github.com/tesseract-ocr/tessdata_best)

USAGE:

```bash
# bash
docker run --rm -v your_path_to_image:/tmp/image juzai/tesseract /tmp/image stdout
```



[docker hub](https://hub.docker.com/r/juzai/tesseract)