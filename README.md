# wbb
Wirtualny Bank Bitcoinów


# Potrzebne narzędzia:

 <b>docker</b>
 <b>pip</b>
 <b>virtualenv</b>
 <b>PostgreSQL</b>

 Należy stworzyć wirtualne środowisko dla serwera Django, uruchomić je komendą <code>source path/to/venv/bin/activate</code> (Linux) lub <code>path\to\venv\Scripts\activate.ps1</code> (Windows), a następnie zainstalować konieczne pakiety z pliku <i>requirements.txt</i> komendą <code>pip install -r requirements.txt</code>.


# Uruchomienie obrazu RabbitMQ w dockerze

Przed uruchomieniem serwera aplikacji WBB konieczne jest włączenie pomocniczego programu RabbitMQ. W tym celu wykorzystamy przygotowany przez społeczność RabbitMQ obraz <b>dockera</b>:

 <code>docker run -d -p 5672:5672 rabbitmq</code>


# ...teraz jest najlepszy moment na uruchomienie serwera Django

Uruchom stworzone wcześniej<b>środowisko wirtualne virtualenv</b>, a następnie z poziomu folderu </i>../bank_backend</i> wykonaj komendy:
 <code>pyhon manage.py makemigrations</code>
 <code>pyhon manage.py migrate</code>
 <code>pyhon manage.py runserver</code>


# ...od razu potem powinieneś uruchomić programy- planery zadań okresowych

Serwer aplikacji WBB do poprawnego działania polega na zadaniach wykonywanych w tle. 

- Aby je uruchomić, po wykonaniu wszystkich poprzednich kroków, włącz nowe okno terminala, przejdź do folderu </i>../bank_backend</i>, uruchom stworzone wcześniej<b>środowisko wirtualne virtualenv</b>, a następnie wykonaj komendę:
 <code>celery -A bank_backend worker</code>

- Następnie włącz drugie okno terminala, wykonaj te same kroki zaczynając od przejścia do folderu </i>../bank_backend</i>, tym razem wykonaj inną komendę:
 <code>celery -A bank_backend beat</code>

 # Uruchamianie Fluttera

 Przejdź do folderu ../bank i wykonaj:
 <code>flutter channel beta</code>
 <code>flutter config --enable-web</code>
 <code>flutter run -d chrome</code>



