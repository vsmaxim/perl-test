## Версия perl
Тестовое задание запускалось на perl v5.26.0.
Для установки пакетов perl требуется cpan.

## Инструкции по запуску
Для установки пакетов запустить `./requirements.sh`. 
Далее, для работы с программой использовать один из следующих вариантов:
1. `perl test.pl -v` просмотр всех автомобилей
2. `perl test.pl -v DD.MM.YYYY DD.MM.YYYY` просмотр всех автомобилей, находящихся в эксплуатации в указанный период времени
3. `perl test.pl -a /path/to/img DD.MM.YYYY DD.MM.YYYY` добавления автомобиля с указанием пути до скана птс, даты введения в эксплуатацию, даты вывода из эксплуатации.  


