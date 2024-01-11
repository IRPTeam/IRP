# Путь к директории, где находятся папки
$directoryPath = ".\IRP\src\Roles"

# Создание массива из имен всех папок первого уровня
$folderNames = Get-ChildItem -Path ".\IRP\src\AccumulationRegisters" -Directory | Select-Object -ExpandProperty Name

$i = 0
foreach ($folder in $folderNames) {

    $i++

    $rightPath = "TemplateAccumulationRegisters$i"
    
    # Путь к файлу Rights.rights
    $rightsFilePath = "$directoryPath\$rightPath\Rights.rights"
    # Путь ко второму XML-файлу в папке
    $secondXmlFilePath = "$directoryPath\$rightPath\$rightPath.mdo"

    # Загрузка содержимого XML
    $xmlContent = [xml](Get-Content $rightsFilePath)

    $objectsToRemove = $xmlContent.Rights.object | Where-Object {
        -not $_.name.Contains(".$folder")
    }

    foreach ($object in $objectsToRemove) {
        $xmlContent.Rights.RemoveChild($object) | Out-Null
    }

    # Сохранение изменений в файл
    $xmlContent.Save($rightsFilePath)

    # Получение нового имени папки и файла из первого тега <name> в <object>
    $newName = "AccumulationRegisters_$folder"

    # Загрузка содержимого второго XML-файла
    $secondXmlContent = [xml](Get-Content $secondXmlFilePath)

    # Изменение элемента <name> и <value> в <synonym>
    $secondXmlContent.Role.name = $newName
    $secondXmlContent.Role.synonym.value = $newName -replace "_", " "

    # Сохранение изменений в файле
    $secondXmlContent.Save($secondXmlFilePath)

    # Переименование второго файла в соответствии с новым именем папки
    Rename-Item $secondXmlFilePath -NewName "$newName.mdo"

    # Переименование папки
    Rename-Item $directoryPath\$rightPath -NewName $newName
}

# Вывод названий папок в нужном формате
$folderNames | ForEach-Object {
    Write-Output "<roles>Role.TemplateAccumulationRegisters$_</roles>"
}
