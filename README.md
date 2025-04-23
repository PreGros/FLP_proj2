# Logický projekt do předmětu FLP

## Hlavička

- **Jméno:** Tomáš Zaviačič  
- **Login:** xzavia00  
- **Akademický rok:** 2024/2025  
- **Název zadání:** Kostra grafu  

## Popis použité metody

Pro nalezení koster v neorientovaném grafu jsem zvolil metodu vygenerování všech kandidátů na kostry grafu a jejich následnou kontrolu na souvislost.

Kandidáty na kostry grafu generuji jako všechny možné kombinace hran vstupního neorientovaného grafu bez opakování o velikosti:
$$|V| - 1$$
kde $V$ je počet vrcholů vstupního neorientovaného grafu. Takové kombinace tvoří všechny možné potenciální kostry, protože každá kostra souvislého neorientovaného grafu má právě $|V| - 1$ hran a žádné cykly. Každého kandidáta kontroluji na souvislost prohledávním do hloubky. To najde všechny dostupné vrcholy z libovolného vrcholu. Kandidát je kostrou grafu, pokud nalezne všechny ostatní vrcholy vstupního neorientovaného grafu. V opačném případě se nejedná o kostru grafu. 

### Vnitřní stavy programu

Celý program začíná v `main` predikátu. Postupně se v něm získává a kontroluje vstup, hledají všechny vrcholy vstupního neorientovaného grafu, určuje kolik hran budou mít výsledné kostry grafu, generují kandidáti na kostry, kontroluje souvislost u každého kandidátu a nakonec vypisují nalezené kostry. 

Program nejdříve zpracuje vstupní data ze standardního vstupu do seznamu. Podle zadání se na vstupu očekávají hrany na každém řádku reprezentovány dvojicí vrcholů oddělené mezerou. Vstup může končit novým řádkem. Jakékoliv jiné informace na řádcích program ignoruje. Program se ukončí a nic nevypisuje, pokud neorientovaný graf na vstupu není souvislý. Vstup se zpracovává pomocí predikátu `start_load_input/1` z modulu `input2.pl`, který je převzaný z [podkladů](https://moodle.vut.cz/pluginfile.php/1109152/mod_resource/content/1/input2.pl) na ELEARNING stránkách do předmětu FLP dostupných pro logický projekt. Predikáty řešicí popsanou logiku jsou `start_load_input/1`, `onlyEdges/2` a `checkIfConnected/2`.

Vrcholy vstupního neorientovaného grafu se hledají pomocí rekurzivního procházení vstupních hran a postupným doplněním vrcholů do seznamu, které se v něm ještě nenacházejí. To řeší předikát `uniqueList/2`.

Dále program vypočítá kolik hran budou mít výsledné kostry pomocí $|V| - 1$, kde $V$ jsou vrcholy vstupního neorientovaného grafu. Výpočet provádí predikát `getSpanEdgeCount/2`.

Pomocí vstupních hran a počtu hran v každé kostře grafu lze nyní vygenerovat kandidáty na kostru jako kombinace hran vstupního neorientovaného grafu bez opakování. Velikost kombinací je právě počet hran v každé kostře grafu. To provádí predikát `getNumCandidates/3`. Samotné generování se provádí pomocí `noRepeatCombination/3`, které prohledává stavový prostor podobně jako prohledávání do hloubky s omezenou výškou. Je upravený tak, že vrací pouze výsledky v zadané maximální hloubce a pokud prohledá celý stavový prostor do maximální výšky, přeskočí aktuální prvek a pokračuje s dalším s upravenou výškou. Aby se zamezilo zbytečnému prohledávání stavového prostoru ve chvíli, kdy již má všechny kombinace, tak predikát `getNumCandidates/3` počítá kolik daných kombinací bez opakování existuje a pomocí vestavěnému predikátu `findnsols/4` z **SWI-Prolog** vygeneruje pouze daný počet kombinací.

Kontrola souvisloti jednotlivých kandidátů se vykonává v predikátu `dropWithCycle/3`. Souvislost se zkontroluje tak, že u daného kandidátu se najdou všechny vrcholy dostupné z libovolného vrcholu (včetně daného vrcholu) a ty se porovnají se všemi vrcholy ze vstupního neorientovaného grafu. Pokud obsahuje všechny vrcholy, tak se lze z libovolného vrcholu dostat do všech ostatních (podmínka souvislosti) a daný kandidát je kostrou grafu. Nalezené vrcholy můžou být ve špatném pořadí, takže se kontroluje jejich shoda pomocí vestavěného predikátu `subset/2` z **SWI-Prolog**. Hledání dosažitelných vrcholů zajišťuje predikát `deepSearchInit/2`, který vkládá dynamické predikáty hran oběma směry do databáze (např. hranu A-B vloží jako `edge('A','B')` i `edge('B','A')` ) a spustí prohledávání do hloubky predikátem `deepSearch/2`. Ten pomocí dříve vložených dynamických predikátu prohledává stavový prostor a po využití dané hrany vymaže oba dynamické predikáty (oba směry) z databáze.

Poslední částí programu je výpis nalezených koster grafu na standardní výstup. Vypisuje se každá kostra na samostatný řádek, kdy kostra je ve formátu hran oddělenými mezerou a každá hrana sestává z dvojicí vrcholů oddělenými pomlčkou. Konec výstupu je zakončený novým řádkem. Výpis provádí predikát `writeAllST/1`.

## Požadavky

- **SWI-Prolog (threaded, 64 bits, version 9.2.9)**
- **Python 3.8.20+**

## Spouštění

### Kompilace projektu

Pro zkompilování **SWI-Prolog** programu do spustitelného souboru:
 
```
make
```

Vytvořený spustitelný soubor je pojmenovaný `flp24-log`.

### Spouštění projektu

Po zkompilování programu stačí spustitelný spustit s přiloženými vstupy ve složce `inputs` například:

```
./flp24-log < inputs/pr1.txt
```

### Testing

### Cleaning up

## Input format

## Output format