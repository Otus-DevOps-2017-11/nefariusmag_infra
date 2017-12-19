Dmitriy Erokhin - nefariusmag
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

```gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=https://raw.githubusercontent.com/Otus-DevOps-2017-11/nefariusmag_infra/Infra-2/Startup.sh```

Homework 5
---
ssh -A 35.198.103.134 'ssh 10.156.0.3'
alias internalhost="ssh -A 35.198.103.134 'ssh 10.156.0.3'"

---
Хост bastion, IP: 35.198.103.134, внутр. IP: 10.156.0.2.
Хост: someinternalhost, внутр. IP: 10.156.0.3 
