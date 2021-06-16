# Role strongswan

Role pro konfiguraci StrongSwan IPSec serveru. Momentálně konfigurujeme pouze
site-to-site tunnely (IPSec režim tunnel). Používáme protkoly IKEv1 a IKEv2
a ESP hlavičku.

Podporované metody autentizace jsou:

- PSK (Preshared key),
- RSA/ECDSA klíče.
- PKI vzájemné ověření certifikáty (server i klient).

## Nastavení spojení

### Proměnné

Nastavení jednotlivých spojení se řeší polem slovníků `strongswan.connections`.

| Proměnná                 | Povinná | Výchozí | Popis |
| ------------------------ | ------- | ------- | ----- |
| name                     | ano     |         | Jméno spojení |
| mobike                   | ne      | no      | Zapnutí funkce mobike |
| proposals                | ne      | aes256-sha1-modp2048 | Seznam propozic pro crypto |
| version                  | ne      | 2       | Verze IKE protokolu (1 nebo 2). |
| pools                    | ne      |         | Pole přidělovaných virtuálních IP adres |
| unique                   | ne      | no      | Parametr ovlivňující unikátnost spojení. Pro umožnění připojení více zařízení pod stejným uživatelem nás zajímá hodnota `never` |
| send_cert                | ne      | ifasked | Nastavení určuje, za jakých podmínek server posílá svůj certifikát během autentizace pomocí certifikátů. S výchozím `ifasked` jej posílá pouze pokud si jej klient vyžadá, což třeba macOS standardně nedělá. S `always` jej posílá vždy |
| dpd_delay                | ne      | 0       | Nastavení pro zasílání DPD zpráv |
|                          |         |         |       |
| local                    | ano     |         | Slovník pro nastavení lokálního bodu spojení |
| .auth                    | ne      | psk     | Typ autentizace. Podporované medody: psk, pubkey, rsa a ecdsa. rsa a ecdsa jsou synonyma pro pubkey |
| .id                      | ano     |         | ID lokálního bodu |
| .addrs                   | ano     |         | Pole s adresami lokálního bodu |
| .pubkeys                 | ne      |         | Pole jmen souborů s veřejnými klíči pro typ autentizace pubkey, rsa nebo ecdsa |
| .certs                   | ne      |         | Pole jmen souborů s certifikáty nacházejícími se v adresáři x509 pro typ autentizace pubkey. |
|                          |         |         |       |
| remote                   | ano     |         | Slovník pro nastavení vzdáleného bodu spojení |
| .auth                    | ne      | pubkey  | Typ autentizace |
| .id                      | ano     |         | ID vzdáleného bodu |
| .addrs                   | ne      |         | Pole s adresami vzdáleného bodu |
| .pubkeys                 | ne      |         | Pole jmen souborů s veřejnými klíči pro typ autentizace pubkey, rsa nebo ecdsa |
|                          |         |         |       |
| children                 | ano     |         | Pole slovníků pro nastavení IPSec CHILD_SA |
| .name                    | ano     |         | Název CHILD_SA |
| .start_action            | ne      | trap    | Způsob inicializace tunelu |
| .close_action            | ne      | clear   | Akce, jenž bude vyvolána po řádném ukončení spojení |
| .dpd_action              | ne      | none    | Akce, jenž bude vyvolána, pokud bude detekován stav "Dead Peer" |
| .remote_ts               | ne      |         | Pole sítí specifických pro vzdálený uzel |
| .local_ts                | ano     |         | Pole sítí specifických pro lokální uzel |
|                          |         |         |       |
| secret                   | ano     |         | Slovník pro nastavení zabezpečení spojení |
| .type                    | ne      | ike     | Typ zabezpečení. `ike` pro PSK. `rsa`, `ecdsa`, `private` pro RSA/ECDSA klíče. |
| .file                    | ano     |         | Jméno souboru privátního klíče (pouze RSA/ECDSA) |
| .password                | ano     |         | Heslo (pouze PSK) |

Všechny výchozí hodnoty proměnných jsou uloženy ve slovníku `strongswan.default`.
Ten můžeme použít pro přenastavení výchozí hodnoty, aby nebylo nutné stejné nastavení
specifikovat u více spojení.

Pooly IP adres specifikujeme seznamem slovníkem `strongswan.pools`.

| Proměnná                 | Povinná | Výchozí | Popis |
| ------------------------ | ------- | ------- | ----- |
| name                     | ano     |         | Jméno poolu |
| addrs                    | ano     |         | Pole s adresami poolu |
| attributes               | ne      |         | Pole se slovníky atributy |
| .name                    | ano     |         | Jméno/číslo atributu |
| .params                  | ano     |         | Pole hodnot atributu |


[Nastavení](https://wiki.strongswan.org/projects/strongswan/wiki/strongswanconf) `charon` démona provádíme pomocí slovníku `strongswan.charon`.

| Proměnná                 | Povinná | Výchozí | Popis |
| ------------------------ | ------- | ------- | ----- |
| cache_crls               | ne      | no      | Pokud nastavena na true, stronswan začne cachovat CRL v adresáři `x509crl` |
| retransmit_tries         | ne      | 5       | Parametr upravující chování [retransmission](https://wiki.strongswan.org/projects/strongswan/wiki/retransmission) |
| retransmit_timeout       | ne      | 4.0     | Parametr upravující chování [retransmission](https://wiki.strongswan.org/projects/strongswan/wiki/retransmission) |
| retransmit_base          | ne      | 1.3     | Parametr upravující chování [retransmission](https://wiki.strongswan.org/projects/strongswan/wiki/retransmission) |

Pro zjednodušení nastavení uživatelské VPN s PSK autentizací lze použít pole slovníků `strongswan.user_connections`.
Velká část nastavení je obdobná jako u `strongswan.connections`.

| Proměnná                 | Povinná | Výchozí | Popis |
| ------------------------ | ------- | ------- | ----- |
| mobike                   | ne      | no      | - - - |
| proposals                | ne      | aes256-sha1-modp2048 | - - - |
| version                  | ne      | 2       | - - - |
| pools                    | ne      |         | - - - |
| unique                   | ne      | no      | Parametr ovlivňující unikátnost spojení. Pro umožnění připojení více zařízení pod stejným uživatelem nás zajímá hodnota `never` |
| dpd_delay                | ne      | 0       | - - - |
|                          |         |         |       |
| local                    | ano     |         | - - - |
| .auth                    | ne      | psk     | - - - |
| .id                      | ano     |         | ID lokálního bodu. Bude použito v konfiguraci na straně klienta. |
| .addrs                   | ano     |         | - - - |
|                          |         |         |       |
| remote                   | ne      |         | - - - |
| .auth                    | ne      | pubkey  | - - - |
|                          |         |         |       |
| children                 | ano     |         | - - - |
| .name                    | ano     |         | - - - |
| .start_action            | ne      | trap    | - - - |
| .close_action            | ne      | clear   | - - - |
| .dpd_action              | ne      | none    | - - - |
| .local_ts                | ano     |         | - - - |
|                          |         |         |       |
| users                    | ano     |         | Pole slovníků pro nastavení uživatelských účtů |
| .name                    | ano     |         | Jméno spojení |
| .pools                   | ano     |         | Pole názvů poolu virtuálních adres, ze kterých se bude uživateli přidělovat |
| .id                      | ano     |         | Remote ID. Například username |
| .secret                  | ano     |         | Slovník pro nastavení autentizace |
| ..password               | ano     |         | Heslo (PSK) uživatele |


## Konfigurace privátních klíčů

**Pozor!!!**. Toto funguje pouze v režimu jednoho serveru. Pokud používáme HA režim,
klíče se vytvoří pouze na `master` uzlu. Na `backup` je musíme momentálně zkopírovat
ručně.

Pro autentizaci pomocí RSA/ECDSA klíčů můžeme na serveru vygenerovat pár privátní/veřejný
klíč polem slovníků `strongswan.private_keys`.

Privátní klíče jsou vygenerovány v adresáři `/etc/swanctl/{{ item.type}}/{{ item.private_key_name }}`
Veřejné klíče jsou vygenerovány v adresáři `/etc/swanctl/pubkey/{{ item.public_key_name }}`


| Proměnná                 | Povinná | Výchozí | Popis |
| ------------------------ | ------- | ------- | ----- |
| type                     | ne      | rsa     | Typ šifry pro strongswan konfiguraci |
| cipher                   | ne      | RSA     | Typ šifry pro Ansible modul `openssl_privatekey`  |
| private_key_name         | ano     |         | Název souboru s privátním klíčem |
| public_key_name          | ano     |         | Název souboru s veřejným klíčem |


## Nahrání veřejných klíčů na server

Pro autentizaci pomocí RSA/ECDSA klíčů můžeme na server nahrát veřejný klíč polem slovníků
`strongswan.public_keys`.

Klíče jsou v Ansible repozitáři umístěny v adresáři `files/ipsec-keys` se jménem
`{{ item.name }}`. Veřejné klíče jsou zkopírovány do adresáře
`/etc/swanctl/pubkey/{{ item.name }}`.


| Proměnná                 | Povinná | Výchozí | Popis |
| ------------------------ | ------- | ------- | ----- |
| name                     | ano     |         | Jméno souboru s veřejných klíčem na cílovém serveru |


## Nahrání CA certifikátů na server

Pro autentizace pomocí certifikátů potřebujeme do Strongswan dodat certifikáty autorit,
kterým důvěřujeme. Ty definuje pole slovníků `strongswan.cacerts`.

| Proměnná                 | Povinná | Výchozí                  | Popis   |
| ------------------------ | ------- | ------------------------ | ------- |
| name                     | ano     |                          | Jméno souboru s veřejných klíčem na cílovém serveru |
| path                     | ne      | files/cacerts/{{ name }} | Cesta k souboru, který budeme kopírovat |


## Konfigurace certifikačních autorit

Ve Strongswan konfiguraci můžeme definovat certifikační autority. Hodí se to zejména
pro specifikování CRL/OCSP pro kontrolu revokace certifikátů. Nastavení specifikuje
v poli slovníků `strongswan.authorities`.

| Proměnná                 | Povinná | Výchozí                  | Popis   |
| ------------------------ | ------- | ------------------------ | ------- |
| name                     | ano     |                          | Název autority v konfiguraci |
| cacert                   | ne      | {{ item.name }}.pem      | Název souboru certifikátu CA umístněného v adresáři `x509ca` |
| crl_uris                 | ne      |                          | Pole obsahující jedno nebo více URL ke (vzdálenému) CRL souboru |
| ocsp_uris                | ne      |                          | Pole obsahující jedno nebo více URL OSCP bodů |

Pro cachování CRL je nutné upravit konfiguraci démona `charon` viz výše.


## Import koncových certifikátů

Strongswan balík má na Debianu zapnutý Apparmor profile, kdy nemůže přistupovat k souborům
mimo své konfigurační adresář. Z tohoto důvodu zde existuje mechanismus pro automatizovaný
import certifikátů.

Automatický import se nastaví, pokud pole `strongswan_certsync` obsahuje aspoň
jednu položku. Import skript je spouštěn pod uživatelem `root` automaticky každou hodinu
pomocí cronu. Konfigurace pomocí pole slovníků `strongswan_certsync`:

| Proměnná                 | Povinná | Výchozí                  | Popis   |
| ------------------------ | ------- | ------------------------ | ------- |
| name                     | ano     |                          | Název certifikátu. Použije se pro jména souborů ve Strongswan konfiguračních adresářích |
| cert                     | ano     |                          | Cesta k souboru certifikátu. Bude nahrán do `/etc/swanctl/x509/{{ name }}.pem` |
| crl_uris                 | ano     |                          | Cesta k souboru privátního klíče. Bude nahrán do `/etc/swanctl/{{ "rsa" if rsa | default(false) else "ecdsa" }}/{{ name }}.pem` |
| rsa                      | ne      | false                    | Přepne typ privátního klíče z výchozího `ecdsa` na `rsa`.  |

Příklad:

```
strongswan_certsync:
  - name: 'vpn'
    cert: '/var/lib/estclient/certs/vpn/cert.pem'
    key: '/var/lib/estclient/certs/vpn/key.pem'
    rsa: true
```
