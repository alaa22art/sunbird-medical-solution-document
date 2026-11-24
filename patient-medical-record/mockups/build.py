"""Generate static HTML screens for the PMR blueprint screenshots."""
import os

OUT = os.path.join(os.path.dirname(__file__), "screens")
os.makedirs(OUT, exist_ok=True)

HEAD = """<!doctype html><html lang="en"><head><meta charset="utf-8">
<link rel="stylesheet" href="../sunbird-patient-plate.css">
<style>
@font-face{font-family:'Barlow Condensed';font-weight:500;src:url(../fonts/barlow-condensed-latin-500-normal.woff2)}
@font-face{font-family:'Inter';font-weight:400;src:url(../fonts/inter-latin-400-normal.woff2)}
@font-face{font-family:'Inter';font-weight:500;src:url(../fonts/inter-latin-500-normal.woff2)}
@font-face{font-family:'Inter';unicode-range:U+0600-06FF;font-weight:400 500;src:url(../fonts/noto-sans-arabic-arabic-400-normal.woff2)}
body{margin:0;font-family:Inter,sans-serif;color:#10272B;background:#F4F7F8}
a{color:inherit}
.nav{width:64px;flex-shrink:0;background:#0C2E33;display:flex;justify-content:center;padding-top:18px}
.logo{width:30px;height:30px;border-radius:8px;background:#2CC5D6}
.h1{margin:0;font-size:22px;font-weight:500}
.sel{height:32px;padding:0 8px;border:1px solid #D9E1E3;border-radius:8px;font:13px Inter,sans-serif;background:#fff}
</style></head><body>"""
FOOT = "</body></html>"

FLAG = {k: f"../flags/{k.lower()}.svg" for k in ["SA", "JO", "EG", "IN", "PK", "YE"]}
NATION = {"SA": "Saudi Arabia", "JO": "Jordan", "EG": "Egypt", "IN": "India", "PK": "Pakistan", "YE": "Yemen"}
OK = "M3 8.5l3.2 3.2L13 4.8"
NO = "M3.5 12.5L12.5 3.5"
MALE = '<svg class="sb-plate__sex-icon" viewBox="0 0 16 16"><circle cx="6.5" cy="9.5" r="4" fill="none" stroke="currentColor" stroke-width="1.6"/><path d="M9.5 6.5L14 2M10 2h4v4" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>'
FEMALE = '<svg class="sb-plate__sex-icon" viewBox="0 0 16 16"><circle cx="8" cy="6" r="4" fill="none" stroke="currentColor" stroke-width="1.6"/><path d="M8 10v5M5.5 12.5h5" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/></svg>'
UNK = '<svg class="sb-plate__sex-icon" viewBox="0 0 16 16"><circle cx="8" cy="8" r="4.5" fill="none" stroke="currentColor" stroke-width="1.6" stroke-dasharray="2 1.6"/></svg>'
SEX = {"M": (MALE, "Male"), "F": (FEMALE, "Female"), "U": (UNK, "Unknown")}
LOCK = '<svg viewBox="0 0 16 16"><rect x="3.5" y="7" width="9" height="6.5" rx="1" fill="none" stroke="currentColor" stroke-width="1.5"/><path d="M5.5 7V5a2.5 2.5 0 0 1 5 0v2" fill="none" stroke="currentColor" stroke-width="1.5"/></svg>'

# k, nation, branch, mrn, flags, allergy, verified, stay(label,value), name, ar, sex, dob, loc, variants
P = [
    dict(k="IP", n="SA", b="OLY", mrn="0012 3456", fl="I", a=True, v=True, st=("day", "5"), name="Ahmed AL-RASHIDI", ar="أحمد الرشيدي", g="M", dob="12-Mar-1972 (54y)", loc="MED 12-B · Dr. Khalid", sel=True),
    dict(k="IP", n="SA", b="OLY", mrn="0051 2207", fl="N", a=False, v=True, st=("day", "3"), name="Mohammed AL-SHEHRI", ar="محمد الشهري", g="M", dob="11-Jun-1968 (58y)", loc="MED 14-A · Dr. Khalid", alert=True),
    dict(k="IP", n="YE", b="OLY", mrn="0052 8810", fl="NF", more="+1", a=True, v=False, st=("day", "1"), name="Mohammad AL-SHEHRI", ar="محمد الشهري", g="M", dob="05-Dec-1970 (55y)", loc="MED 15-B · Dr. Khalid", alert=True),
    dict(k="IP", n="SA", b="OLY", mrn="0018 7702", fl="VD", a=False, v=True, st=("day", "2"), name="Fahad AL-QAHTANI", ar="فهد القحطاني", g="M", dob="03-Jul-1955 (71y)", loc="CCU 03-A · Dr. Noura"),
    dict(k="ED", n="SA", b="OLY", mrn="0021 0094", fl="F", a=True, v=False, st=("time", "02:40"), name="Mona AL-HARBI", ar="منى الحربي", g="F", dob="19-Jan-1987 (39y)", loc="ED Bay 4 · Dr. Saeed"),
    dict(k="ED", n=None, b="MLQ", mrn="0044 9087", fl="", a=False, v=False, st=("time", "00:35"), name="Unknown patient — trauma", ar="مجهول الهوية", g="U", dob="DOB unknown, est. 55y", loc="ED Resus 1 · Dr. Saeed", unid=True),
    dict(k="IP", n="IN", b="OLY", mrn="0009 4411", fl="", a=False, v=True, st=("out", "23/11"), name="Rajesh KUMAR", ar="راجيش كومار", g="M", dob="08-Sep-1979 (47y)", closed="Closed · Home"),
    dict(k="DC", n="JO", b="NRJ", mrn="0027 5513", fl="", a=True, v=True, st=("out", "24/11"), name="Omar HADDAD", ar="عمر حداد", g="M", dob="14-Feb-1964 (62y)", closed="Closed · Home"),
    dict(k="IP", n="PK", b="OLY", mrn="0016 3390", fl="", a=False, v=True, st=("died", "23/11"), name="Abdullah KHAN", ar="عبدالله خان", g="M", dob="21-Aug-1948 (78y)", loc="MED 16-A · Dr. Khalid", dead=True),
    dict(k="PA", n="EG", b="NRJ", mrn="0038 6620", fl="F", a=True, v=False, st=("day", "—"), name="Huda MANSOUR", ar="هدى منصور", g="F", dob="30-Oct-1960 (66y)", loc="ORT · admit 26-Nov · Dr. Faisal"),
    dict(k="OP", n="SA", b="OLY", mrn="0033 1280", fl="", a=False, v=True, st=("time", "10:15"), name="Sara AL-OTAIBI", ar="سارة العتيبي", g="F", dob="22-May-1998 (28y)", loc="Clinic 01 · Dr. Reem"),
    dict(k="IP", n="SA", b="MLQ", mrn="0040 0021", fl="I", a=False, v=False, st=("day", "3"), name="Lina AL-DOSARI", ar="لينا الدوسري", g="F", dob="02-Apr-2020 (6y)", loc="PED 08-A · Dr. Majed"),
]
CLS = {"IP": "ip", "OP": "op", "ED": "ed", "DC": "day", "PA": "pre"}


def sex_tag(g):
    icon, word = SEX[g]
    return f'<span class="sb-plate__sex">{icon}{word}</span>'


def plate(p, selected=None):
    cls = f"sb-plate sb-plate--{CLS[p['k']]}"
    if p.get("dead"):
        cls += " sb-plate--deceased"
    if p.get("unid"):
        cls += " sb-plate--unidentified"
    if p.get("closed"):
        cls += " sb-plate--closed"
    if (selected is None and p.get("sel")) or selected:
        cls += " sb-plate--selected"
    flag = f'<img class="sb-plate__nation-flag" src="{FLAG[p["n"]]}" alt="">' if p["n"] else '<span class="sb-plate__nation-flag sb-plate__nation-flag--unknown"></span>'
    alg = '<span class="sb-plate__sticker sb-plate__sticker--allergy">ALG</span>' if p["a"] else '<span class="sb-plate__sticker sb-plate__sticker--nka">NKA</span>'
    seal = f'<span class="sb-plate__sticker sb-plate__seal{" sb-plate__seal--verified" if p["v"] else ""}"><svg viewBox="0 0 16 16"><path d="{OK if p["v"] else NO}" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/></svg></span>'
    more = f'<span class="sb-plate__flag-more">{p["more"]}</span>' if p.get("more") else ""
    tag = ""
    if p.get("alert"):
        tag = '<span class="sb-plate__tag sb-plate__tag--name-alert">Similar name</span>'
    if p.get("dead"):
        tag = '<span class="sb-plate__tag sb-plate__tag--deceased">Deceased</span>'
    right = f'<span class="sb-plate__tag sb-plate__tag--closed">{LOCK}{p["closed"]}</span>' if p.get("closed") else f'<span class="sb-plate__location">{p["loc"]}</span>'
    return f"""<a class="{cls}" href="#">
<div class="sb-plate__row"><div class="sb-plate__band">{flag}<span class="sb-plate__class">{p['k']}</span></div>
<div class="sb-plate__body"><span class="sb-plate__branch">{p['b']}</span><div class="sb-plate__stickers">{alg}{seal}</div>
<span class="sb-plate__id"><span class="sb-plate__id-label">MRN</span><span class="sb-plate__mrn">{p['mrn']}</span></span><span class="sb-plate__flags">{p['fl']}{more}</span></div>
<div class="sb-plate__stay"><span class="sb-plate__stay-label">{p['st'][0]}</span><span class="sb-plate__stay-value">{p['st'][1]}</span></div></div>
<div class="sb-plate__info"><div class="sb-plate__identity"><span class="sb-plate__name">{p['name']}</span><span class="sb-plate__name-ar" dir="rtl">{p['ar']}</span></div>
<div class="sb-plate__detail"><span class="sb-plate__dob">{sex_tag(p['g'])}<span>{p['dob']}</span>{tag}</span>{right}</div></div></a>"""


def context_chip(scope="All branches"):
    return f'<div class="sb-context" style="margin-top:6px"><span class="sb-context__tenant">Al Rajhi Medical Center <span class="sb-context__code">AR-MED-001</span></span><span>›</span><span>{scope}</span></div>'


def board_header(title="Patient board", view="cards"):
    c_on = " sb-toggle__btn--active" if view == "cards" else ""
    l_on = " sb-toggle__btn--active" if view == "list" else ""
    return f"""<div style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:12px;margin-bottom:16px">
<div><h1 class="h1">{title}</h1>{context_chip()}</div>
<div style="display:flex;gap:8px;align-items:center"><select class="sel"><option>All branches</option></select>
<input class="sb-input" style="width:220px" placeholder="MRN, name or national ID">
<div class="sb-toggle"><button class="sb-toggle__btn{c_on}">Cards</button><button class="sb-toggle__btn{l_on}">List</button></div></div></div>"""


def chips():
    data = [("All", "#0C2E33", 12, True), ("Inpatient", "#185FA5", 8, False), ("Outpatient", "#3B6D11", 1, False), ("Emergency", "#A32D2D", 2, False), ("Day case", "#534AB7", 1, False), ("Pre-admit", "#5F5E5A", 1, False)]
    h = '<div class="sb-toolbar">'
    for label, col, n, on in data:
        h += f'<button class="sb-chip{" sb-chip--active" if on else ""}"><span class="sb-chip__dot" style="background:{col}"></span>{label} · {n}</button>'
    h += '<span style="margin-left:12px;font-size:13px;color:#5A6E72">Encounter</span><div class="sb-toggle"><button class="sb-toggle__btn sb-toggle__btn--active">Open + closed 24h · 12</button><button class="sb-toggle__btn">Open · 9</button><button class="sb-toggle__btn">Closed · 3</button></div></div>'
    return h


def banner(closed=False):
    state = '<span class="sb-banner__chip sb-banner__chip--closed">Closed · discharged home 23-Nov</span>' if closed else ""
    adm = "19-Nov → 23-Nov · 4 days" if closed else "19-Nov 14:20 · day 5"
    return f"""<div class="sb-banner sb-banner--ip"><div class="sb-banner__top"><span class="sb-banner__class"><img class="sb-plate__nation-flag" src="../flags/sa.svg" alt="">IP · OLY</span>
<a class="sb-banner__name" href="#">AL-RASHIDI, Ahmed</a><span class="sb-banner__name-ar" dir="rtl">أحمد الرشيدي</span></div>
<div class="sb-banner__fields"><span><span class="sb-banner__label">MRN</span><span class="sb-banner__value sb-banner__value--mono">0012 3456</span></span>
<span><span class="sb-banner__label">DOB · Age</span><span class="sb-banner__value">12-Mar-1972 · 54y</span></span>
<span><span class="sb-banner__label">Sex</span><span class="sb-banner__value">♂ Male</span></span>
<span><span class="sb-banner__label">Location</span><a class="sb-banner__value" href="#">OLY · MED 12-B</a></span>
<span><span class="sb-banner__label">Admitted</span><span class="sb-banner__value">{adm}</span></span>
<span><span class="sb-banner__label">Attending</span><span class="sb-banner__value">Dr. Khalid</span></span></div>
<div class="sb-banner__alerts"><span class="sb-banner__label">Allergies</span><a class="sb-banner__chip sb-banner__chip--allergy-high" href="#">Penicillin · high</a><a class="sb-banner__chip sb-banner__chip--allergy" href="#">Contrast</a>
<span class="sb-banner__chip sb-banner__chip--flag">Contact isolation</span><span class="sb-banner__chip sb-banner__chip--verified">✓ ID verified</span>{state}</div></div>"""


def actionbar(closed=False):
    if closed:
        return '<div class="sb-actionbar"><button class="sb-actionbar__btn sb-actionbar__btn--primary">Late entry (reason required)</button></div>'
    return '<div class="sb-actionbar"><button class="sb-actionbar__btn sb-actionbar__btn--primary">New order</button><button class="sb-actionbar__btn">Record vitals</button><button class="sb-actionbar__btn">Transfer</button><button class="sb-actionbar__btn">Discharge</button><button class="sb-actionbar__btn">More ▾</button></div>'


TABS = ["Summary", "Visits", "Results", "Orders", "Vitals", "Diagnoses", "Appointments", "Allergies & medications", "Coverage", "Audit"]


def tabs(active):
    h = '<div class="sb-tabs">'
    for t in TABS:
        cnt = '<span class="sb-tabs__count">2</span>' if t == "Results" else ""
        h += f'<button class="sb-tabs__tab{" sb-tabs__tab--active" if t == active else ""}">{t}{cnt}</button>'
    return h + "</div>"


def summary(cols=1):
    grid = "repeat(2,minmax(0,1fr))" if cols == 2 else "minmax(0,1fr)"
    return f"""<div style="display:grid;grid-template-columns:{grid};gap:12px">
<div class="sb-card"><h2 class="sb-card__title">Current encounter</h2><div class="sb-kv"><span class="sb-kv__key">Status</span><span><span class="sb-status sb-status--open">Open · in-progress</span></span>
<span class="sb-kv__key">Admitted</span><span>19-Nov-2026 14:20 · day 5</span><span class="sb-kv__key">Location</span><span>OLY · MED · 12-B</span><span class="sb-kv__key">Attending</span><span>Dr. Khalid Al-Faisal</span><span class="sb-kv__key">Diagnosis</span><span>Pneumonia, unspecified (J18.9)</span></div></div>
<div class="sb-card"><h2 class="sb-card__title">Visit history · last 12 months</h2><div style="display:grid;grid-template-columns:repeat(5,1fr);gap:6px;text-align:center">
<div style="background:#F4F7F8;border-radius:6px;padding:6px"><div style="font-size:18px;font-weight:500">14</div><div style="font-size:11px;color:#5A6E72">Total</div></div>
<div style="background:#E6F1FB;border-radius:6px;padding:6px;color:#0C447C"><div style="font-size:18px;font-weight:500">2</div><div style="font-size:11px">IP</div></div>
<div style="background:#EAF3DE;border-radius:6px;padding:6px;color:#27500A"><div style="font-size:18px;font-weight:500">9</div><div style="font-size:11px">OP</div></div>
<div style="background:#FCEBEB;border-radius:6px;padding:6px;color:#791F1F"><div style="font-size:18px;font-weight:500">3</div><div style="font-size:11px">ED</div></div>
<div style="background:#EEEDFE;border-radius:6px;padding:6px;color:#3C3489"><div style="font-size:18px;font-weight:500">0</div><div style="font-size:11px">DC</div></div></div>
<div style="margin-top:8px;font-size:13px">Last visit: ED · 02-Nov-2026</div><div style="margin-top:6px;display:flex;gap:6px"><span class="sb-status sb-status--pending">Readmission ≤ 30 days</span><span class="sb-status sb-status--cancelled">No ED return ≤ 72h</span></div></div>
<div class="sb-card"><h2 class="sb-card__title">Safety and alerts</h2><div style="display:grid;gap:6px;font-size:13px">
<div style="display:flex;justify-content:space-between;padding:6px 8px;border:2px solid #412402;border-radius:6px;background:#FAEEDA;color:#412402"><span><b style="font-weight:500">Penicillin</b> — anaphylaxis</span><span>High</span></div>
<div style="display:flex;justify-content:space-between;padding:6px 8px;border:1px solid #EF9F27;border-radius:6px;color:#633806"><span><b style="font-weight:500">Iodinated contrast</b> — rash</span><span>Low</span></div>
<div style="display:flex;justify-content:space-between;align-items:center;padding:6px 8px;border-radius:6px;background:#FCEBEB;color:#791F1F"><span><b style="font-weight:500">Critical:</b> Potassium 6.2 mmol/L (HH) · 06:40</span><button class="sb-btn" style="min-height:28px;border-color:#A32D2D;color:#791F1F">Acknowledge</button></div></div></div>
<div class="sb-card"><h2 class="sb-card__title">Orders and results</h2><div style="display:flex;gap:6px;margin-bottom:8px"><span class="sb-status sb-status--pending">Pending lab · 1</span><span class="sb-status sb-status--pending">Pending radiology · 1</span><span class="sb-status sb-status--critical">New abnormal · 2</span></div>
<table class="sb-table"><tr><td>Potassium</td><td class="sb-labflag sb-labflag--hh">6.2 mmol/L</td><td class="sb-labflag sb-labflag--hh">HH</td></tr><tr><td>Creatinine</td><td class="sb-labflag sb-labflag--h">168 µmol/L</td><td class="sb-labflag sb-labflag--h">H</td></tr><tr><td>Troponin I</td><td>0.02 ng/mL</td><td class="sb-labflag sb-labflag--n">N</td></tr></table></div>
<div class="sb-card"><h2 class="sb-card__title">Latest vitals · 07:00</h2><div style="display:grid;grid-template-columns:repeat(3,1fr);gap:6px;font-size:13px"><span>HR <b style="font-weight:500">98</b> /min</span><span>BP <b style="font-weight:500">128/82</b></span><span>RR <b style="font-weight:500;color:#633806">22</b> /min</span><span>SpO₂ <b style="font-weight:500;color:#633806">93</b> %</span><span>Temp <b style="font-weight:500;color:#633806">38.1</b> °C</span><span>NEWS2 <b style="font-weight:500;color:#633806">5 · medium</b></span></div></div>
<div class="sb-card"><h2 class="sb-card__title">Active diagnoses</h2><div style="font-size:13px;display:grid;gap:4px"><span>J18.9 · Pneumonia, unspecified <span class="sb-status sb-status--open">primary</span></span><span>E11.9 · Type 2 diabetes without complications</span><span>I10 · Essential hypertension</span></div></div></div>"""


def panel(tab="Summary", body=None, width="420px", cols=1, closed=False, header=True):
    body = body if body is not None else summary(cols)
    head = '<div style="display:flex;justify-content:space-between;align-items:center"><span style="font-size:13px;color:#5A6E72">Patient record · open encounter</span><button class="sb-btn" style="min-height:32px;width:32px;padding:0">✕</button></div>' if header else ""
    return f'<aside style="width:{width};box-sizing:border-box;padding:16px;display:grid;gap:12px;align-content:start;background:#F4F7F8">{head}{banner(closed)}{actionbar(closed)}{tabs(tab)}{body}</aside>'


def page(name, inner, w=1440, extra=""):
    with open(os.path.join(OUT, name + ".html"), "w") as f:
        f.write(HEAD + f'<div style="width:{w}px;display:flex;min-height:100vh">' + inner + "</div>" + extra + FOOT)


# S01 board
cards = "".join(plate(p, selected=False) for p in P[:12])
page("S01_board", f'<nav class="nav"><div class="logo"></div></nav><main style="flex:1;padding:24px">{board_header()}{chips()}<div class="sb-board" style="grid-template-columns:repeat(3,minmax(0,1fr))">{cards}</div></main>')

# S02 board + panel
cards2 = "".join(plate(p) for p in P[:8])
page("S02_board_panel", f'<nav class="nav"><div class="logo"></div></nav><main style="flex:1;min-width:0;padding:24px">{board_header()}{chips()}<div class="sb-board" style="grid-template-columns:repeat(2,minmax(0,1fr))">{cards2}</div></main><div style="border-left:1px solid #D9E1E3">{panel()}</div>')

# list rows / table
FOLDERS = [("My patients", "9", True, False), ("MED · Medical ward", "4", False, False), ("CCU · Coronary care", "1", False, False), ("ED · Emergency", "2", False, False), ("PED · Paediatrics", "1", False, False), ("Pre-admissions", "1", False, False), ("Closed in 24h", "2", False, False), ("New results", "3", False, True)]


def folders():
    h = '<nav style="width:220px;flex-shrink:0;background:#0C2E33;color:#E6F4F5;padding:18px 10px;box-sizing:border-box;display:flex;flex-direction:column;gap:2px;font-size:14px"><div style="display:flex;align-items:center;gap:8px;padding:0 6px 14px"><div class="logo" style="width:26px;height:26px"></div><span style="font-weight:500;color:#fff">Sunbird EMR</span></div><span style="padding:4px 6px 8px;font-size:12px;color:#9FC6CC">Al Rajhi Medical Center › All branches</span><span style="padding:6px;font-size:11px;color:#9FC6CC;letter-spacing:.5px">MY LISTS</span>'
    for label, n, on, hot in FOLDERS:
        st = "background:rgba(44,197,214,.25);box-shadow:inset 0 0 0 1.5px #2CC5D6;color:#fff" if on else "color:#E6F4F5"
        cnt = f'<span style="min-width:20px;padding:0 6px;border-radius:10px;background:#2CC5D6;color:#04342C;font-size:12px;font-weight:500;text-align:center">{n}</span>' if hot else f'<span style="font-size:12px;color:#9FC6CC">{n}</span>'
        h += f'<a href="#" style="display:flex;justify-content:space-between;align-items:center;min-height:36px;padding:0 10px;border-radius:6px;text-decoration:none;{st}"><span>{label}</span>{cnt}</a>'
    return h + "</nav>"


GROUPS = [("MED · Medical ward", [0, 1, 2, 8]), ("CCU · Coronary care", [3]), ("ED · Emergency", [4, 5]), ("PED · Paediatrics", [11]), ("Closed in the last 24 hours", [6, 7])]
UNREAD = {0, 2, 4}
BAND = {"IP": "#185FA5", "ED": "#A32D2D", "DC": "#534AB7", "OP": "#3B6D11", "PA": "#5F5E5A"}


def row_tags(p):
    if p.get("alert"):
        return '<span class="sb-plate__tag sb-plate__tag--name-alert">Similar name</span>'
    if p.get("dead"):
        return '<span class="sb-plate__tag sb-plate__tag--deceased">Deceased</span>'
    if p.get("closed"):
        return f'<span class="sb-plate__tag sb-plate__tag--closed">{LOCK}{p["closed"]}</span>'
    return ""


def list_rows():
    h = '<div class="sb-list">'
    for g, idx in GROUPS:
        h += f'<div class="sb-list__group">▾ {g}<span style="margin-left:auto;font-weight:400">{len(idx)}</span></div>'
        for i in idx:
            p = P[i]
            cls = f"sb-list__row sb-list__row--{CLS[p['k']]}" + (" sb-list__row--selected" if i == 0 else "") + (" sb-list__row--unread" if i in UNREAD else "") + (" sb-list__row--closed" if p.get("closed") else "") + (" sb-list__row--deceased" if p.get("dead") else "")
            alg = '<span class="sb-list__alg sb-list__alg--allergy">ALG</span>' if p["a"] else '<span class="sb-list__alg sb-list__alg--nka">NKA</span>'
            loc = (p.get("loc") or "").split(" · ")[0]
            age = p["dob"].split("(")[-1].rstrip(")") if "(" in p["dob"] else "est. 55y"
            h += f'<a href="#" class="{cls}"><span class="sb-list__dot"></span><span class="sb-list__main"><span class="sb-list__line"><span class="sb-list__name">{p["name"]}</span><span class="sb-list__stay">{p["st"][0]} {p["st"][1]}</span></span><span class="sb-list__meta"><span class="sb-list__pill">{p["k"]}</span>MRN {p["mrn"]} · {age} {SEX[p["g"]][1]} · {loc}{row_tags(p)}</span></span><span class="sb-list__side">{alg}<span class="sb-list__flags">{p["fl"]}{p.get("more", "")}</span></span></a>'
    return h + "</div>"


def list_table():
    h = '<div class="sb-card" style="padding:0;overflow:hidden"><table class="sb-table"><tr><th style="width:12px"></th><th>Class</th><th>Patient</th><th>MRN</th><th>Age · Sex</th><th>Location ▾</th><th>Stay</th><th>Alerts</th></tr>'
    for g, idx in GROUPS:
        for i in idx:
            p = P[i]
            sel = ' style="background:#E6F7F9;box-shadow:inset 0 0 0 2px #2CC5D6"' if i == 0 else (' style="color:#5A6E72"' if p.get("closed") else "")
            col = "#2C2C2A" if p.get("dead") else BAND[p["k"]]
            pill = f'<span class="sb-list__pill" style="background:#fff;color:{col};border:1px dashed {col}">{p["k"]}</span>' if p.get("closed") else f'<span class="sb-list__pill" style="background:{col}">{p["k"]}</span>'
            dot = '<span class="sb-list__dot" style="background:#185FA5;display:inline-block"></span>' if i in UNREAD else ""
            alg = '<span class="sb-list__alg sb-list__alg--allergy">ALG</span>' if p["a"] else '<span class="sb-list__alg sb-list__alg--nka">NKA</span>'
            age = p["dob"].split("(")[-1].rstrip(")") if "(" in p["dob"] else "est. 55y"
            h += f'<tr{sel}><td>{dot}</td><td>{pill}</td><td><span style="font-weight:{500 if i in UNREAD else 400}">{p["name"]}</span><div>{row_tags(p)}</div></td><td style="font-family:\'Barlow Condensed\';font-size:16px">{p["mrn"]}</td><td>{age} · {SEX[p["g"]][1]}</td><td style="color:#5A6E72">{(p.get("loc") or "—").split(" · ")[0]}</td><td style="color:#5A6E72">{p["st"][0]} {p["st"][1]}</td><td>{alg} <span class="sb-list__flags">{p["fl"]}</span></td></tr>'
    return h + "</table></div>"


def list_head(mode):
    r = " sb-toggle__btn--active" if mode == "rows" else ""
    t = " sb-toggle__btn--active" if mode == "table" else ""
    return f'<div style="display:flex;justify-content:space-between;align-items:center"><div><div style="font-size:20px;font-weight:500">My patients</div><div style="font-size:12px;color:#5A6E72">9 patients · grouped by ward · open + closed 24h</div></div><div class="sb-toggle"><button class="sb-toggle__btn{r}">Rows</button><button class="sb-toggle__btn{t}">Table</button></div></div><input class="sb-input" placeholder="Search in My patients"><div style="display:flex;gap:8px;font-size:13px;color:#5A6E72;align-items:center">Group by <select class="sel"><option>Ward</option></select> Sort <select class="sel"><option>Location</option></select></div>'


page("S03_list_rows", folders() + f'<section style="width:460px;flex-shrink:0;box-sizing:border-box;padding:18px 16px;display:flex;flex-direction:column;gap:10px;border-right:1px solid #D9E1E3">{list_head("rows")}{list_rows()}</section><div style="flex:1;min-width:0">{panel(width="100%", cols=2)}</div>')
page("S04_list_table", folders() + f'<section style="flex:1;min-width:0;box-sizing:border-box;padding:18px 16px;display:flex;flex-direction:column;gap:10px;border-right:1px solid #D9E1E3">{list_head("table")}{list_table()}</section><div style="width:420px;flex-shrink:0">{panel()}</div>')


def record(name, tab, body, closed=False, extra=""):
    if closed and body is None:
        body = summary(2).replace('<span class="sb-status sb-status--open">Open · in-progress</span>', '<span class="sb-status sb-status--cancelled">Closed · discharged home 23-Nov</span>').replace("19-Nov-2026 14:20 · day 5", "19-Nov-2026 14:20 → 23-Nov-2026 12:00").replace('<button class="sb-btn" style="min-height:28px;border-color:#A32D2D;color:#791F1F">Acknowledge</button>', '<span class="sb-status sb-status--done">Acknowledged</span>')
    page(name, f'<nav class="nav"><div class="logo"></div></nav><main style="flex:1;min-width:0"><div style="padding:16px 24px 0;display:flex;justify-content:space-between;align-items:center"><span style="font-size:13px;color:#5A6E72">Patient list › <b style="font-weight:500;color:#10272B">Full record</b></span>{context_chip("OLY · Main Branch")}</div>{panel(tab, body, width="100%", cols=2, closed=closed, header=False)}</main>', extra=extra)


record("S05_record_summary", "Summary", None)


def tbl(head, rows, alert_rows=()):
    h = '<div class="sb-card" style="padding:0;overflow:hidden"><table class="sb-table"><tr>' + "".join(f"<th>{c}</th>" for c in head) + "</tr>"
    for i, r in enumerate(rows):
        h += f'<tr{" class=sb-table__row--alert" if i in alert_rows else ""}>' + "".join(f"<td>{c}</td>" for c in r) + "</tr>"
    return h + "</table></div>"


def filters(*items):
    return '<div class="sb-toolbar" style="margin:0">' + "".join(items) + "</div>"


def seg(*opts):
    return '<div class="sb-toggle">' + "".join(f'<button class="sb-toggle__btn{" sb-toggle__btn--active" if i == 0 else ""}">{o}</button>' for i, o in enumerate(opts)) + "</div>"


S = lambda c, t: f'<span class="sb-status sb-status--{c}">{t}</span>'
pill = lambda k: f'<span class="sb-list__pill" style="background:{BAND[k]}">{k}</span>'

record("S06_record_visits", "Visits", filters(seg("All", "IP", "OP", "ED", "DC"), '<select class="sel"><option>Last 12 months</option></select>') + tbl(
    ["Class", "Start", "End", "Branch · location", "Attending", "Main diagnosis", "Outcome"],
    [[pill("IP"), "19-Nov-2026 14:20", "—", "OLY · MED 12-B", "Dr. Khalid", "J18.9 Pneumonia", S("open", "Open")],
     [pill("ED"), "02-Nov-2026 21:05", "03-Nov-2026 02:40", "OLY · ED Bay 2", "Dr. Saeed", "R50.9 Fever", S("done", "Discharged home")],
     [pill("OP"), "15-Oct-2026 10:00", "15-Oct-2026 10:25", "OLY · Clinic 04", "Dr. Reem", "E11.9 Diabetes review", S("done", "Visit complete")],
     [pill("IP"), "20-Sep-2026 08:10", "24-Sep-2026 12:00", "NRJ · MED 03-A", "Dr. Khalid", "J44.1 COPD exacerbation", S("done", "Discharged home")],
     [pill("OP"), "01-Aug-2026 09:30", "01-Aug-2026 09:50", "OLY · Clinic 04", "Dr. Reem", "I10 Hypertension", S("done", "Visit complete")],
     [pill("ED"), "11-Jun-2026 23:40", "12-Jun-2026 03:15", "MLQ · ED Bay 5", "Dr. Saeed", "R07.4 Chest pain", S("done", "Discharged home")]]))

record("S07_record_results", "Results", filters(seg("All", "Lab", "Radiology"), '<label style="font-size:13px;display:flex;gap:6px;align-items:center"><input type="checkbox" checked> Abnormal first</label>', '<button class="sb-btn">Mark all as reviewed</button>') + tbl(
    ["", "Test", "Result", "Flag", "Reference", "Collected", "Status", ""],
    [['<span class="sb-list__dot" style="display:inline-block;background:#185FA5"></span>', "<b style='font-weight:500'>Potassium</b>", '<span class="sb-labflag sb-labflag--hh">6.2 mmol/L</span>', '<span class="sb-labflag sb-labflag--hh">HH</span>', "3.5 – 5.1", "24-Nov 06:40", S("critical", "Critical · not acknowledged"), '<button class="sb-btn" style="min-height:28px;border-color:#A32D2D;color:#791F1F">Acknowledge</button>'],
     ['<span class="sb-list__dot" style="display:inline-block;background:#185FA5"></span>', "<b style='font-weight:500'>Creatinine</b>", '<span class="sb-labflag sb-labflag--h">168 µmol/L</span>', '<span class="sb-labflag sb-labflag--h">H</span>', "62 – 106", "24-Nov 06:40", S("done", "Final"), ""],
     ["", "Troponin I", "0.02 ng/mL", '<span class="sb-labflag sb-labflag--n">N</span>', "< 0.04", "23-Nov 22:10", S("done", "Final"), ""],
     ["", "CBC — WBC", '<span class="sb-labflag sb-labflag--h">13.8 ×10⁹/L</span>', '<span class="sb-labflag sb-labflag--h">H</span>', "4.0 – 11.0", "23-Nov 22:10", S("done", "Final"), ""],
     ["", "Chest X-ray PA", "Right lower lobe consolidation", "—", "—", "19-Nov 15:30", S("done", "Final report"), ""]], alert_rows=(0,)))

record("S08_record_orders", "Orders", filters(seg("Active", "All", "Completed", "Cancelled"), '<button class="sb-btn sb-btn--primary">New order</button>') + tbl(
    ["Order", "Category", "Priority", "Ordered", "By", "Status"],
    [["CBC with differential", "Lab", "Routine", "24-Nov 07:10", "Dr. Khalid", S("pending", "Ordered")],
     ["Chest X-ray PA", "Radiology", "Urgent", "24-Nov 07:12", "Dr. Khalid", S("pending", "Scheduled 10:00")],
     ["Potassium, repeat", "Lab", "Stat", "24-Nov 06:55", "Dr. Khalid", S("open", "In progress")],
     ["Blood culture × 2", "Lab", "Routine", "19-Nov 15:00", "Dr. Khalid", S("done", "Completed")],
     ["CT chest", "Radiology", "Routine", "20-Nov 09:00", "Dr. Khalid", S("cancelled", "Cancelled")]]))

# vitals with simple svg trend
def spark(vals, col):
    xs = [20 + i * 60 for i in range(len(vals))]
    lo, hi = min(vals), max(vals)
    ys = [70 - (v - lo) / ((hi - lo) or 1) * 50 for v in vals]
    pts = " ".join(f"{x},{y:.0f}" for x, y in zip(xs, ys))
    dots = "".join(f'<circle cx="{x}" cy="{y:.0f}" r="3" fill="{col}"/>' for x, y in zip(xs, ys))
    return f'<svg viewBox="0 0 400 80" width="100%" height="80"><polyline points="{pts}" fill="none" stroke="{col}" stroke-width="2"/>{dots}</svg>'


vit_cards = ""
for name, unit, vals, col in [("Heart rate", "/min", [88, 92, 95, 101, 98, 96], "#185FA5"), ("Temperature", "°C", [37.6, 38.4, 38.9, 38.3, 38.1, 37.9], "#A32D2D"), ("SpO₂", "%", [95, 94, 92, 91, 93, 94], "#0F6E56"), ("Respiratory rate", "/min", [18, 20, 24, 23, 22, 20], "#534AB7")]:
    vit_cards += f'<div class="sb-card"><h2 class="sb-card__title">{name} <span style="font-weight:400;color:#5A6E72">· latest {vals[-1]} {unit}</span></h2>{spark(vals, col)}<div style="display:flex;justify-content:space-between;font-size:11px;color:#5A6E72"><span>22-Nov</span><span>23-Nov</span><span>24-Nov</span></div></div>'
record("S09_record_vitals", "Vitals", filters(seg("72 hours", "7 days", "Encounter"), '<button class="sb-btn sb-btn--primary">Record vitals</button>', '<span class="sb-status sb-status--pending">NEWS2 5 · medium</span>') + f'<div style="display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px">{vit_cards}</div>' + tbl(
    ["Time", "HR", "BP", "RR", "SpO₂", "Temp", "By"],
    [["24-Nov 07:00", "98", "128/82", "22", "93", "38.1", "Nurse Amal"], ["24-Nov 03:00", "101", "132/85", "23", "91", "38.3", "Nurse Amal"], ["23-Nov 23:00", "95", "126/80", "24", "92", "38.9", "Nurse Huda"]]))

record("S10_record_diagnoses", "Diagnoses", filters(seg("Active", "Resolved", "All"), '<button class="sb-btn sb-btn--primary">Add diagnosis</button>') + tbl(
    ["Code (ICD-10-AM)", "Diagnosis", "Type", "Encounter", "Recorded", "Status"],
    [["J18.9", "Pneumonia, unspecified", "Primary", "IP 19-Nov-2026", "19-Nov 16:00 · Dr. Khalid", S("open", "Active")],
     ["E11.9", "Type 2 diabetes mellitus without complications", "Chronic", "OP 15-Oct-2026", "15-Oct · Dr. Reem", S("open", "Active")],
     ["I10", "Essential (primary) hypertension", "Chronic", "OP 01-Aug-2026", "01-Aug · Dr. Reem", S("open", "Active")],
     ["J44.1", "COPD with acute exacerbation", "Secondary", "IP 20-Sep-2026", "20-Sep · Dr. Khalid", S("cancelled", "Resolved")]]))

record("S11_record_appointments", "Appointments", filters(seg("Upcoming", "Past"), '<button class="sb-btn sb-btn--primary">Book appointment</button>') + tbl(
    ["Date and time", "Clinic", "Provider", "Reason", "Status"],
    [["02-Dec-2026 10:00", "Pulmonology · OLY", "Dr. Hana", "Post-discharge follow-up", S("open", "Booked")],
     ["15-Dec-2026 09:30", "Endocrinology · OLY", "Dr. Reem", "Diabetes review", S("open", "Booked")],
     ["10-Jan-2027 11:00", "Cardiology · NRJ", "Dr. Noura", "Hypertension review", S("pending", "Waiting list")]]))

record("S12_record_allergies", "Allergies & medications", '<div style="display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px">' + '<div style="display:grid;gap:8px;align-content:start">' + filters('<span style="font-size:14px;font-weight:500">Allergies</span>', '<span class="sb-banner__chip sb-banner__chip--allergy-high" style="font-size:12px">Status: ALG (high)</span>', '<button class="sb-btn">Record allergy</button>', '<button class="sb-btn">Record NKA</button>') + tbl(
    ["Substance", "Category", "Reaction", "Criticality", "Verified"],
    [["<b style='font-weight:500'>Penicillin</b>", "Medication", "Anaphylaxis", '<span class="sb-labflag sb-labflag--hh">High</span>', "Confirmed · 2019"],
     ["Iodinated contrast", "Medication", "Rash", '<span class="sb-labflag sb-labflag--h">Low</span>', "Confirmed · 2024"]]) + '<div class="sb-notice sb-notice--warning">No allergy recorded = <b style="font-weight:500">NR (not recorded)</b>, never shown as NKA.</div></div>' + '<div style="display:grid;gap:8px;align-content:start">' + filters('<span style="font-size:14px;font-weight:500">Medications</span>', seg("Active", "All")) + tbl(
    ["Medication", "Dose · route · frequency", "Since", "Status"],
    [["Ceftriaxone", "2 g · IV · once daily", "19-Nov", S("open", "Active")], ["Azithromycin", "500 mg · PO · once daily", "19-Nov", S("open", "Active")], ["Metformin", "500 mg · PO · twice daily", "2024", S("pending", "On hold")], ["Amlodipine", "5 mg · PO · once daily", "2023", S("open", "Active")]]) + "</div></div>")

record("S13_record_coverage", "Coverage", '<div style="display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px"><div class="sb-card"><h2 class="sb-card__title">Insurance</h2><div class="sb-kv"><span class="sb-kv__key">Payer</span><span>Bupa Arabia</span><span class="sb-kv__key">Policy</span><span>BA-2291-77013</span><span class="sb-kv__key">Class</span><span>A · inpatient covered</span><span class="sb-kv__key">Valid</span><span>01-Jan-2026 to 31-Dec-2026</span><span class="sb-kv__key">Eligibility</span><span>' + S("done", "Eligible") + ' <span style="font-size:12px;color:#5A6E72">checked 19-Nov 14:25 via NPHIES</span></span></div><div style="margin-top:10px;display:flex;gap:8px"><button class="sb-btn">Check eligibility again</button></div></div><div style="display:grid;gap:8px;align-content:start"><span style="font-size:14px;font-weight:500">Pre-authorisations</span>' + tbl(
    ["Service", "Requested", "Status"], [["Inpatient admission — 5 days", "19-Nov 14:30", S("done", "Approved")], ["CT chest", "20-Nov 09:05", S("cancelled", "Rejected")], ["Extension — 3 days", "24-Nov 08:00", S("pending", "Pending")]]) + "</div></div>")

record("S14_record_audit", "Audit", filters(seg("All", "Views", "Changes"), '<select class="sel"><option>Last 7 days</option></select>', '<button class="sb-btn">Export</button>') + tbl(
    ["Time", "User", "Action", "Area", "Detail"],
    [["24-Nov 07:41", "Dr. Khalid", "Viewed record", "Results", "—"], ["24-Nov 07:12", "Dr. Khalid", "Created", "Order", "Chest X-ray PA, urgent"], ["24-Nov 07:00", "Nurse Amal", "Created", "Vitals", "HR 98, BP 128/82, SpO₂ 93"], ["23-Nov 18:20", "Reg. Fatimah", "Updated", "Patient details", "Phone number changed"], ["23-Nov 09:02", "Pharm. Sami", "Viewed record", "Allergies & medications", "—"]]))


# dialogs
def dialog(name, title, body, foot, closed=False):
    record(name, "Summary", None, closed=closed, extra=f'<div class="sb-dialog-backdrop"><div class="sb-dialog" role="dialog"><div class="sb-dialog__head"><h2 class="sb-dialog__title">{title}</h2><div class="sb-dialog__patient">AL-RASHIDI, Ahmed · MRN 0012 3456 · DOB 12-Mar-1972 · IP · OLY MED 12-B</div></div><div class="sb-dialog__body">{body}</div><div class="sb-dialog__foot">{foot}</div></div></div>')


F = lambda label, ctl, hint="": f'<div class="sb-field"><label class="sb-label">{label}</label>{ctl}{hint}</div>'
CANCEL = '<button class="sb-btn">Cancel</button>'

dialog("S15_dialog_new_order", "New order", F("Category", '<div class="sb-toggle"><button class="sb-toggle__btn sb-toggle__btn--active">Lab</button><button class="sb-toggle__btn">Radiology</button></div>') + F("Test", '<input class="sb-input" value="Potassium (serum)">', '<span class="sb-hint">Search by name or code</span>') + F("Priority", '<div class="sb-toggle"><button class="sb-toggle__btn">Routine</button><button class="sb-toggle__btn">Urgent</button><button class="sb-toggle__btn sb-toggle__btn--active">Stat</button></div>') + F("Note", '<textarea class="sb-textarea">Repeat after critical result 6.2</textarea>') + '<div class="sb-notice sb-notice--warning">Allergy check: no conflict with Penicillin or Iodinated contrast.</div>', CANCEL + '<button class="sb-btn sb-btn--primary">Place order</button>')
dialog("S16_dialog_transfer", "Transfer patient", F("From", '<input class="sb-input" value="OLY · MED · 12-B" disabled>') + F("To branch", '<select class="sb-select"><option>OLY · Main Branch - Al Olaya</option></select>') + F("To ward and bed", '<div style="display:flex;gap:8px"><select class="sb-select" style="flex:1"><option>CCU · Coronary care</option></select><select class="sb-select" style="width:120px"><option>04-A</option></select></div>') + F("Reason", '<textarea class="sb-textarea">Haemodynamic monitoring</textarea>'), CANCEL + '<button class="sb-btn sb-btn--primary">Transfer</button>')
dialog("S17_dialog_discharge", "Discharge patient", F("Disposition", '<select class="sb-select"><option>Home</option></select>') + F("Discharge date and time", '<input class="sb-input" value="24-Nov-2026 12:00">') + F("Note", '<textarea class="sb-textarea">Oral antibiotics for 5 days; follow-up 02-Dec pulmonology</textarea>') + '<div class="sb-notice sb-notice--danger">After discharge the encounter is closed and read-only. Later documentation needs a late entry with a reason.</div>', CANCEL + '<button class="sb-btn sb-btn--danger">Discharge and close encounter</button>')
dialog("S18_dialog_late_entry", "Late entry — closed encounter", F("Entry type", '<select class="sb-select"><option>Add diagnosis</option></select>') + F("Diagnosis", '<input class="sb-input" value="E87.5 Hyperkalaemia">') + F("Reason for late entry", '<textarea class="sb-textarea">Coding review after discharge summary</textarea>', '<span class="sb-hint">At least 10 characters. Stored with your name and time.</span>'), CANCEL + '<button class="sb-btn sb-btn--primary">Save late entry</button>', closed=True)
dialog("S19_dialog_acknowledge", "Acknowledge critical result", '<div class="sb-notice sb-notice--danger"><b style="font-weight:500">Potassium 6.2 mmol/L (HH)</b> · reference 3.5 – 5.1 · collected 24-Nov 06:40</div>' + F("Action taken", '<textarea class="sb-textarea">Doctor informed at 06:52; repeat potassium ordered stat; ECG done</textarea>', '<span class="sb-hint">Required. Recorded with your name and time.</span>'), CANCEL + '<button class="sb-btn sb-btn--primary">Acknowledge</button>')

# component sheet
variants = [P[0], P[10], P[4], P[7], P[9], P[6], P[8], P[5], P[2]]
labels = ["Inpatient · open · selected", "Outpatient · open", "Emergency · open", "Day case · closed", "Pre-admission", "Inpatient · closed", "Deceased", "Unidentified", "Similar name · 3 flags"]
cells = "".join(f'<div><div style="font-size:12px;color:#5A6E72;margin-bottom:6px">{l}</div>{plate(p, selected=(i == 0))}</div>' for i, (p, l) in enumerate(zip(variants, labels)))
page("S20_components", f'<main style="flex:1;padding:24px"><h1 class="h1" style="margin-bottom:16px">Patient plate — variants</h1><div class="sb-board" style="grid-template-columns:repeat(3,minmax(0,1fr))">{cells}</div></main>')
print("ok", len(os.listdir(OUT)))
