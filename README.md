Dmitriy Erokhin - nefariusmag

---
Homework 11
---

Ansible работа с плейбуками.

Деплой бд и приложения, используя теги, хосты из инвентори, хендлеры и настраивая packer для работы с ansible.

Для проверки плейбука используется --check
Для ограничения хостов для работы используется --limit <db>

Настройка БД:
```
ansible-playbook reddit_app_one_play.yml --limit db --tags db-tag
```
или
```
ansible-playbook reddit_app_multiple_plays.yml --tags db-tag
```
Настройка приложения:
```
ansible-playbook reddit_app_one_play.yml --limit app --tags app-tag
```
или
```
ansible-playbook reddit_app_multiple_plays.yml --tags app-tag
```
Деплой приложения:
```
ansible-playbook reddit_app.yml --limit app --tags deploy-tag
```
или
```
ansible-playbook reddit_app_multiple_plays.yml --tags deploy-tag
```
Настройка БД, приложения и деплой:
```
ansible-playbook site.yml
```
Packer использует плейбуки для конфигурации в образе бд и приложения (packer_db.yml и packer_app.yml) в db.json и app.json

---
Homework 10
---

Работа с ansible

Все хосты на которые ansible может слать команды указываются в файле inventory. Он может быть формата ini, yml, json (кроме ini только с версии ansible 2.4)
Команды отправляются обычно через модули в формате:
```
ansible <хост> -i <путь до файла инвентори> -m <модуль>
ansible appserver -i ./inventory -m ping
```
Чтобы не указывать каждый раз какой инвентори файл будет запущен, а так же имя пользователя и пусть до ключа в каждой строке хоста инвентори можно задать настройки в конфигурации - ansible.cfg

Модули кроме shell и command проверяют состояние системы\файла и не будут выполнять лишнюю работу по второму разу.

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
