class Locale {
    constructor(strings) {
        this.update(strings);
    }

    update(strings) {
        this.strings = strings;
        this.setUI();
    }


    get(key) {
        return this.strings[key];
    }

    setUI() {
        for (const key in this.strings) {
            let element = document.getElementById(key)
            if(!element) continue;
            element.innerHTML = this.get(key);
        }
    }
}

let stringsEN = {
    "text_jobs": "Banen en Inkomen",
    "text_items": "Online balie",
    "text_information": "Mijn info",
    "text_close": "Sluiten",

    "text_identification": "ID-kaarten",
    "desc_identification": "Hieronder kun je zien welke ID-kaarten je momenteel in je zakken hebt.",

    "text_licenses": "Vergunningen",
    "desc_licenses": "Hieronder kun je zien tot welke ID-kaarten je momenteel toegang hebt om te printen.",

    "text_buy": "Kopen",
    "text_apply": "Aanvragen",

    "text_cost": "Kosten: € ",
    "text_salary": "Salaris: € ",
}



const locale = new Locale(stringsEN);