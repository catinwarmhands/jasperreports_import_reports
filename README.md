# Jasperreports автоматический импорт отчётов

Этот скрипт - обёртка над скриптом `/opt/jasper/buildomatic/js-import.sh`, он позволяет ипортировать на Jasperreports сервер сразу много архивов с экспортированными отчётами, и записывает логи в папку `log`

Использование:

```bash
# По умолчанию архивы берутся из папки JR_templates
sh jrs_import_reports.sh

# Опционально, папку с архивами можно указать в качестdе параметра:
sh jrs_import_reports.sh JR_templates
```
