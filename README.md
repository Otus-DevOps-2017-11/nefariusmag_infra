Dmitriy Erokhin - nefariusmag

---
Homework 9
---

Модули в terraform

Создал 3 модуля - db, app, vpc
db - модуль для создание виртуалки и настройки на ней бд mongodb
app - модуль для создания виртуалки и настройки на ней reddit с подключением к mongodb
vpc - модуль для настройки подключения по ssh

Создал два варианта настройки виртуалок - stage и prod
stage - создание среды с возможностью подключаться со всех ip адресов
prod - создание среды с возможностью подключаться только с 46.39.56.7

Настроил еще один внешний модуль stage для хранения state в гугле

Задача со *

Настроил хранение стейт файла в гугловском хранилище через
```
terraform {
  backend "gcs" {
    bucket = "reddit-terraform"
    prefix = "stage"
  }
}
```

Задача со **

Сделал деплой приложения.
Сначала перенастраивается база данных (/etc/mongod.conf), для возможности удаленных подключений.
Потом заливается приложение на сервер приложения с внутреним ip от бд в конфигурции.
```
data "template_file" "pumaservice" {
  template = "${file("../files/puma.service")}"

  vars {
    host_db = "${var.host_db}"
  }
}
provisioner "file" {
  content     = "${data.template_file.pumaservice.rendered}"
  destination = "/tmp/puma.service"
}
```

---
Homework 8
---

Работа с terraform

Если работа идет на новой машине, а не последовательно после задачния с packer, то необходимо авторизовываться с гуглом:
gcloud auth application-default login

Есть шаблон файла с переменными:
terraform.tfvars.example
Необходимо перед работой сделать на основе него файл terraform.tfvars с уже нормальными параметрами.

Запуск идет через команды:
```
terraform plan # план работ
terraform apply # выполнение работ
```

Дополнительно:
```
terraform destroy # удалить указанные в конфиге виртуалки
terraform fmt # отформатировать файлы
```

Задача со *
У меня выходит, что terraform имеет более высокий приоритет и переписывает состояние виртуалки под свою конфигурацию, не дополняя, а синхронизируя с конфигами.

1. Когда я изменил юзера на appuser1, то первоначальный перестал подключаться.
2. Двух (и более) пользователей terraform добавляет без проблем, но запись не очень удобного формата:
```
sshKeys = "${var.user}:${file(var.public_key_path)}\nappuser1:${file(var.public_key_path)}"
```
3. Когда я добавил нового юзера и его ключ через веб, при переконфигурировании тераформ его подчистил.

Задача со **
1. Сделал поднятие двух нод через count

Балансировку не осилил пока, мог бы сделать через создание еще одной ноды с nginx, но думаю зада была как раз в том, чтобы основоить встренные в гугл механизм балансировки.
Посмотрю на праздинках.

---
Homework 7
---

Работа с packer

Аутентификация с гугловским облаком:
gcloud auth application-default login

Запуск packer для дефолтного образа:

```
packer build -var-file=variables.json ubuntu16.json
```

Запуск packer и gcloud для полного образа:

```
packer build -var-file=variables.json immutable.json

gcloud compute instances create reddit-app\
  --image-family reddit-full \
  --tags puma-server \
  --restart-on-failure

```

Сборка идет с помощью скриптов:

install_ruby.sh
install_mongodb.sh
deploy.sh

Чтобы reddit запускался автоматом при старте виртуалки положил в него сервис файл - deamon и настроил на автозапуск

---
Homework 6
---
Скрипты для установки:

deploy.sh  
install_mongodb.sh  
install_ruby.sh

Startup.sh # чтобы выкачать удаленно и запустить

create.sh # чтобы не вбивать команду gcloud

Добавил пару тестиков для прроверки развертывания
На сервере в папке
/home/reddit/install.log

Строка запуска:

```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=https://raw.githubusercontent.com/Otus-DevOps-2017-11/nefariusmag_infra/Infra-2/Startup.sh
```

Homework 5
---
ssh -A 35.198.103.134 'ssh 10.156.0.3'
alias internalhost="ssh -A 35.198.103.134 'ssh 10.156.0.3'"

---
Хост bastion, IP: 35.198.103.134, внутр. IP: 10.156.0.2.
Хост: someinternalhost, внутр. IP: 10.156.0.3
