clear

import excel "C:\Users\HP 1030G3 X360\Desktop\Stage_AMSE\data_all_net.xlsx", firstrow

destring BRET_self BRET_other SVO_angle PG interest_study_nh implication_study_nh interest_study implication_study installation_reprise installation_proximite_famille installation_proximite_etude installation_offre_soin installation_famille installation_aides K_culture K_finance K_med CSP_parent1 CSP_parent2 cc_Q1a cc_Q1b cc_Q1c cc_Q1d cc_Q1e cc_Q1f cc_Q2a cc_Q2c cc_Q2b cc_Q2d cc_Q3 cc_Q4 cc_Q5 cc_Q6 cc_Q7a cc_Q7b cc_Q7c cc_Q7d cc_Q8a cc_Q8b cc_Q8c cc_Q8d cc_Q8e cc_Q9 cc_Q10 cc_Q11a cc_Q11b cc_Q11c cc_Q11d cc_Q11e cc_Q12 cc_Q13 cc_Q14a cc_Q14b cc_Q14c cc_Q14d cc_Q14e cc_Q15 cc_Q16 cc_Q17a cc_Q17b cc_Q17c cc_Q17d cc_Q17e cc_Q18a cc_Q18b cc_Q18c J1 J2 J3 J4 J5 J6 J7 J8 J9 J10 J11 J12 J13 J14 J15 J16 J17 J18 J19 J20 stated_risk risk_health_self risk_health_other risk_finance risk_study stated_patience stated_altruism, replace force




***Calcul du score global de Jefferson
** Renverser certains J
foreach j in J1 J3 J6 J7 J8 J11 J12 J14 J18 {
    gen `j'_inv = 8 - `j'
}

foreach j in J1 J3 J6 J7 J8 J11 J12 J14 J18 {
    replace `j' = 8 - `j'
}


drop J1_inv J3_inv J6_inv J7_inv J8_inv J12_inv J14_inv J18_inv J11_inv
gen J1_inv  = 8 - J1
gen J3_inv  = 8 - J3
gen J6_inv  = 8 - J6
gen J7_inv  = 8 - J7
gen J8_inv  = 8 - J8
gen J11_inv = 8 - J11
gen J12_inv = 8 - J12
gen J14_inv = 8 - J14
gen J18_inv = 8 - J18
gen J19_inv = 8 - J19

egen JSE =rowtotal(J1_inv J2 J3_inv J4 J5 J6_inv J7_inv J8_inv J9 J10 J11_inv J12_inv J13 J14_inv J15 J16 J17 J18_inv J19_inv J20)



// Calcul des sous-scores
gen PT = J2 + J4 + J9 + J10 + J13 + J15 + J16 + J17 + J20 + J1_inv + J3_inv + J6_inv
gen CC = J5 + J7_inv + J8_inv + J11_inv + J12_inv + J14_inv + J18_inv
gen SPS = J19_inv


///***Construction des variables ECOS et CARE

local items_ecos_cc ///
    cc_Q1a cc_Q1b cc_Q1c cc_Q1d cc_Q1e cc_Q1f ///
    cc_Q2a cc_Q2b cc_Q2c cc_Q2d ///
    cc_Q7a cc_Q7b cc_Q7c cc_Q7d ///
    cc_Q8a cc_Q8b cc_Q8c cc_Q8d cc_Q8e

**Vérification des données manquante stockées 
misstable summarize `items_ecos_cc'

* Définir les items ECOS (empathie perçue par un évaluateur)
local items_ecos_cc ///
    cc_Q1a cc_Q1b cc_Q1c cc_Q1d cc_Q1e cc_Q1f ///
    cc_Q2a cc_Q2b cc_Q2c cc_Q2d ///
    cc_Q7a cc_Q7b cc_Q7c cc_Q7d ///
    cc_Q8a cc_Q8b cc_Q8c cc_Q8d cc_Q8e

* Vérifier la cohérence interne
alpha `items_ecos_cc'


foreach var in cc_Q1a cc_Q1b cc_Q1e cc_Q2a cc_Q2d cc_Q8d {
    gen `var'_inv = 6 - `var'
}


* Score ECOS par somme
gen score_ecos_sum = cc_Q1c + cc_Q1f + cc_Q2b + cc_Q2c + cc_Q7b + cc_Q8a + cc_Q8b + cc_Q8e

* OU : moyenne (au lieu de la somme)
egen score_ecos_moy = rowmean(cc_Q1c cc_Q1f cc_Q2b cc_Q2c cc_Q7b cc_Q8a cc_Q8b cc_Q8e)

egen ecos_f1 = rowtotal(cc_Q7a cc_Q7b cc_Q8a cc_Q8b cc_Q1c)
egen ecos_f2 = rowtotal(cc_Q2a_inv cc_Q2b cc_Q2d_inv cc_Q1a_inv)

***////Analyse factorielle exploratoire pour CARE

local items_care_cc ///
    cc_Q2b cc_Q2c cc_Q5 cc_Q6 ///
    cc_Q7b cc_Q7c ///
    cc_Q8b cc_Q8e ///
    cc_Q15 cc_Q18a cc_Q18c

misstable summarize `items_care_cc' ///verification des données manquantes

***le nombre est négligeable (2 pour la plupart 14 pour CARE, 12 pour ECOS, 19 pour las)
**/////
local items_care_cc ///
    cc_Q2b cc_Q2c cc_Q5 cc_Q6 ///
    cc_Q7b cc_Q7c ///
    cc_Q8b cc_Q8e ///
    cc_Q15 cc_Q18a cc_Q18c

alpha `items_care_cc'

***Cohérence interne faible  0.3884 avec 11 items on peut pas regroupé ces variables
//pour créer le score global

***ATERNATIVE: générer ECOS et CARE en faissant la combinaison des variables les plus
**pertinentes pondéré
gen ecos = .
replace ecos = ///
    (cc_Q1c) + ///
    (cc_Q2b == 1) * 5 + ///
    (cc_Q4 == 2 | cc_Q4 == 3) * 4 + ///
    (cc_Q5 == 3 | cc_Q5 == 4) * 5 + ///
    (cc_Q6 == 4) * 5 + ///
    (cc_Q7a + cc_Q7b)/2 + ///
    (cc_Q8a + cc_Q8b)/2 + ///
    (cc_Q9 == 2) * 5 + ///
    (cc_Q15 == 1) * 5 + ///
    (cc_Q18a >= 4)*1 + (cc_Q18c >= 3)*1

gen care = ///
    (cc_Q1c + cc_Q1f)/2 + ///
    (cc_Q2b == 1 | cc_Q2c == 1)*5 + ///
    (cc_Q5 == 3 | cc_Q5 == 4)*5 + ///
    (cc_Q6 == 4)*5 + ///
    (cc_Q7b + cc_Q7c)/2 + ///
    (cc_Q8b + cc_Q8e)/2 + ///
    (cc_Q9 == 2)*5 + ///
    (cc_Q15 == 1 | cc_Q15 == 3)*5 + ///
    (cc_Q18c >= 3)*1

tab ecos
tab care

***////STATISTIQUES DESCRIPTIVES/////

**Recoder la variable parcours (PASS PACES LAS Passerelle)

gen las =.
replace las=1 if origin_study=="LAS"
replace las=0 if origin_study=="PACES"| origin_study=="PASS" | origin_study=="Passerelle"
tab las

gen parcour=. 
replace parcour=1 if origin_study=="LAS"
replace parcour=2 if origin_study=="PACES"
replace parcour=3 if origin_study=="PASS" 
replace parcour=4 if origin_study=="Passerelle"

***Recoder les variables genre, mention bac, education des parents

gen Homme=.
replace Homme=1 if gender=="Male"
replace Homme=0 if gender=="Female"
tab Homme

gen mention_TB=. 
replace mention_TB=1 if mention_bac=="TB"
replace mention_TB=0 if mention_bac=="B" | mention_bac=="AB" | mention_bac=="P"

gen mention_TBB=. 
replace mention_TBB=1 if mention_bac=="TB" | mention_bac=="B"
replace mention_TBB=0 if mention_bac=="AB" | mention_bac=="P"


***études des parents
//gen inf_BAC=.
//replace inf_BAC=1 if inlist(study_parent1 study_parent2, "<BAC")
//replace inf_BAC=1 if inlist(study_parent1 study_parent2, ">BAC3" , "BAC1-3" )//
tab study_parent1
tab study_parent2
gen un_sup_lic = .

* 0 si aucun des deux parents n'a un niveau >BAC3
replace un_sup_lic = 0 if (study_parent1 == "<BAC" | study_parent1 == "BAC1-3") & ///
                         (study_parent2 == "<BAC" | study_parent2 == "BAC1-3")

* 1 si au moins un des deux parents a un niveau >BAC3
replace un_sup_lic = 1 if study_parent1 == ">BAC3" | study_parent2 == ">BAC3"


**/// les deux parents ont un niveau supérieur à BAC
*drop deux_supBAC
gen deux_supBAC = .

* Si au moins un des deux parents a un niveau <BAC → 0
replace deux_supBAC = 0 if study_parent1 == "<BAC" | study_parent2 == "<BAC"

* Si les deux parents ont BAC1-3 ou >BAC3 → 1
replace deux_supBAC = 1 if (study_parent1 == "BAC1-3" | study_parent1 == ">BAC3") & ///
                         (study_parent2 == "BAC1-3" | study_parent2 == ">BAC3")


****La variable de coopération (générosité envers autrui: BRET_self)	
****la variable de confiance interpersonnel: BRET_other
****le gap entre les deux: mesure la différence entre ce qu'on donne et nos attentes: BRET_gap
*** si gap<0 (personne opportuniste)	
****si gap>0 (personne altruiste)

label variable BRET_self "Generosite"
label variable BRET_other "Attente"
rename BRET_self generosite
rename BRET_other attente
gen gen_att= generosite - attente 
sum gen_att				


****//////////
tab year_odontology
***Le jeux de Credence good 
gen CG_conform = .
replace CG_conform = 1 if CG_X == "A" & CG_Y == "B"
replace CG_conform = 0 if CG_X != "A" | CG_Y != "B"
tab CG_conform

****Les variables d'installations
* Recodage de installation_reprise
replace installation_reprise = 1 if inlist(installation_reprise, 1, 2)
replace installation_reprise = 2 if installation_reprise == 3
replace installation_reprise = 3 if inlist(installation_reprise, 4, 5)

* Recodage de installation_proximite_famille
replace installation_proximite_famille = 1 if inlist(installation_proximite_famille, 1, 2)
replace installation_proximite_famille = 2 if installation_proximite_famille == 3
replace installation_proximite_famille = 3 if inlist(installation_proximite_famille, 4, 5)

* Recodage de installation_proximite_etude
replace installation_proximite_etude = 1 if inlist(installation_proximite_etude, 1, 2)
replace installation_proximite_etude = 2 if installation_proximite_etude == 3
replace installation_proximite_etude = 3 if inlist(installation_proximite_etude, 4, 5)

* Recodage de installation_offre_soin
replace installation_offre_soin = 1 if inlist(installation_offre_soin, 1, 2)
replace installation_offre_soin = 2 if installation_offre_soin == 3
replace installation_offre_soin = 3 if inlist(installation_offre_soin, 4, 5)

* Recodage de installation_famille
replace installation_famille = 1 if inlist(installation_famille, 1, 2)
replace installation_famille = 2 if installation_famille == 3
replace installation_famille = 3 if inlist(installation_famille, 4, 5)

* Recodage de installation_aides
replace installation_aides = 1 if inlist(installation_aides, 1, 2)
replace installation_aides = 2 if installation_aides == 3
replace installation_aides = 3 if inlist(installation_aides, 4, 5)

tab installation_aides
tab installation_famille
tab installation_offre_soin
tab installation_proximite_etude
tab installation_proximite_etude
tab installation_reprise

***///////////////////////////////////////
**JSE PT CC SPS stated_risk stated_altruism stated_patience risk_health_other CG_conform generosite attente PG SVO_angle gen_att ecos care Homme un_sup_lic deux_supBAC mention_TB mention_TBB installation_reprise installation_proximite_famille installation_proximite_etude installation_offre_soin installation_famille installation_aides



***etape1
* Variables continues
local vars_cont JSE PT CC SPS stated_risk stated_altruism stated_patience ///
    risk_health_other generosite attente PG SVO_angle gen_att ecos care

* *Variables binaires (0/1)
local vars_bin CG_conform Homme un_sup_lic deux_supBAC ///
    mention_TB mention_TBB installation_reprise installation_proximite_famille ///
    installation_proximite_etude installation_offre_soin installation_famille installation_aides

** Création du document Word avec statistiques descriptives
putdocx clear
putdocx begin

** Titre 
putdocx paragraph, halign(center)
putdocx text ("Statistiques Descriptives")

** Tableau pour variables continues
putdocx paragraph
local ncont : word count `vars_cont'
putdocx table cont = (`=`ncont'+2', 3), border(all, nil) width(100%)

** En-tête du tableau
putdocx table cont(1,1) = ("Variable")
putdocx table cont(1,2) = ("Moyenne"), bold halign(center)
putdocx table cont(1,3) = ("Écart-type"), bold halign(center)

** Remplissage des données
local row = 2
foreach var of local vars_cont {
    quietly summarize `var'
    local mean = r(mean)
    local sd = r(sd)
    local N = r(N)
    
    putdocx table cont(`row',1) = ("`var'")
    putdocx table cont(`row',2) = (string(`mean', "%9.2f")), halign(center)
    putdocx table cont(`row',3) = (string(`sd', "%9.2f")), halign(center)
    
    local ++row
}

*** Ligne du nombre d'observations
putdocx table cont(`row',1) = ("Nombre d'observations"), bold
putdocx table cont(`row',2) = ("`N'"), halign(center) colspan(2)

*** Tableau pour variables binaires
putdocx paragraph
local nbin : word count `vars_bin'
putdocx table bin = (`=`nbin'+2', 3), border(all, nil) width(100%)

*** En-tête du tableau
putdocx table bin(1,1) = ("Variable")
putdocx table bin(1,2) = ("Proportion"), bold halign(center)
putdocx table bin(1,3) = ("Écart-type"), bold halign(center)

*** Remplissage des données
local row = 2
foreach var of local vars_bin {
    quietly summarize `var'
    local mean = r(mean)
    local sd = r(sd)
    local N = r(N)
    
    putdocx table bin(`row',1) = ("`var'")
    putdocx table bin(`row',2) = (string(`mean', "%9.2f")), halign(center)
    putdocx table bin(`row',3) = (string(`sd', "%9.2f")), halign(center)
    
    local ++row
}

***Ligne du nombre d'observations
putdocx table bin(`row',1) = ("Nombre d'observations"), bold
putdocx table bin(`row',2) = ("`N'"), halign(center) colspan(2)

***Sauvegarde du document
putdocx save "Statistiques_Descriptives.docx", replace



****Moyennes et écart types en fonction du parcours
****Moyennes et écart types en fonction du parcours

* Variables continues
local vars_cont JSE PT CC SPS stated_risk stated_altruism stated_patience ///
    risk_health_other generosite attente PG SVO_angle gen_att ecos care

* Variables binaires (0/1)
local vars_bin CG_conform Homme un_sup_lic deux_supBAC ///
    mention_TB mention_TBB installation_reprise installation_proximite_famille ///
    installation_proximite_etude installation_offre_soin installation_famille installation_aides

** Création du document Word avec statistiques par parcours
putdocx clear
putdocx begin

** Titre principal
putdocx paragraph, halign(center)
putdocx text ("Statistiques Descriptives par Parcours LAS"), bold

** Tableau pour variables continues (LAS vs non-LAS)
putdocx paragraph
putdocx text ("Variables continues"), bold

local ncont : word count `vars_cont'
putdocx table cont = (`=`ncont'+3', 5), border(all, single) width(100%)

** En-tête du tableau
putdocx table cont(1,1) = ("Variable"), bold
putdocx table cont(1,2) = ("LAS"), bold halign(center)
putdocx table cont(1,3) = ("Écart-type"), bold halign(center)
putdocx table cont(1,4) = ("Non-LAS"), bold halign(center)
putdocx table cont(1,5) = ("Écart-type"), bold halign(center)

** Remplissage des données
local row = 2
foreach var of local vars_cont {
    * Statistiques pour LAS (1)
    quietly summarize `var' if las == 1
    local mean_las = r(mean)
    local sd_las = r(sd)
    local N_las = r(N)
    
    * Statistiques pour non-LAS (0)
    quietly summarize `var' if las == 0
    local mean_nonlas = r(mean)
    local sd_nonlas = r(sd)
    local N_nonlas = r(N)
    
    putdocx table cont(`row',1) = ("`var'")
    putdocx table cont(`row',2) = (string(`mean_las', "%9.2f")), halign(center)
    putdocx table cont(`row',3) = (string(`sd_las', "%9.2f")), halign(center)
    putdocx table cont(`row',4) = (string(`mean_nonlas', "%9.2f")), halign(center)
    putdocx table cont(`row',5) = (string(`sd_nonlas', "%9.2f")), halign(center)
    
    local ++row
}

** Lignes des nombres d'observations
putdocx table cont(`row',1) = ("Effectifs"), bold
putdocx table cont(`row',2) = ("`N_las'"), halign(center)
putdocx table cont(`row',3) = ("-"), halign(center)
putdocx table cont(`row',4) = ("`N_nonlas'"), halign(center)
putdocx table cont(`row',5) = ("-"), halign(center)

** Tableau pour variables binaires (LAS vs non-LAS)
putdocx paragraph
putdocx text ("Variables binaires"), bold

local nbin : word count `vars_bin'
putdocx table bin = (`=`nbin'+3', 5), border(all, single) width(100%)

** En-tête du tableau
putdocx table bin(1,1) = ("Variable"), bold
putdocx table bin(1,2) = ("LAS"), bold halign(center)
putdocx table bin(1,3) = ("Écart-type"), bold halign(center)
putdocx table bin(1,4) = ("Non-LAS"), bold halign(center)
putdocx table bin(1,5) = ("Écart-type"), bold halign(center)

** Remplissage des données
local row = 2
foreach var of local vars_bin {
    * Statistiques pour LAS (1)
    quietly summarize `var' if las == 1
    local mean_las = r(mean)
    local sd_las = r(sd)
    local N_las = r(N)
    
    * Statistiques pour non-LAS (0)
    quietly summarize `var' if las == 0
    local mean_nonlas = r(mean)
    local sd_nonlas = r(sd)
    local N_nonlas = r(N)
    
    putdocx table bin(`row',1) = ("`var'")
    putdocx table bin(`row',2) = (string(`mean_las', "%9.2f")), halign(center)
    putdocx table bin(`row',3) = (string(`sd_las', "%9.2f")), halign(center)
    putdocx table bin(`row',4) = (string(`mean_nonlas', "%9.2f")), halign(center)
    putdocx table bin(`row',5) = (string(`sd_nonlas', "%9.2f")), halign(center)
    
    local ++row
}

** Lignes des nombres d'observations
putdocx table bin(`row',1) = ("Effectifs"), bold
putdocx table bin(`row',2) = ("`N_las'"), halign(center)
putdocx table bin(`row',3) = ("-"), halign(center)
putdocx table bin(`row',4) = ("`N_nonlas'"), halign(center)
putdocx table bin(`row',5) = ("-"), halign(center)

** Sauvegarde du document
putdocx save "Statistiques_Descriptives_LAS_vs_nonLAS.docx", replace



**** Statistiques descriptives par parcours (LAS, PACES, PASS, Passerelle)

* Variables continues
local vars_cont JSE PT CC SPS stated_risk stated_altruism stated_patience ///
    risk_health_other generosite attente PG SVO_angle gen_att ecos care

* Variables binaires (0/1)
local vars_bin CG_conform Homme un_sup_lic deux_supBAC ///
    mention_TB mention_TBB installation_reprise installation_proximite_famille ///
    installation_proximite_etude installation_offre_soin installation_famille installation_aides

** Création du document Word
putdocx clear
putdocx begin

** Titre principal
putdocx paragraph, halign(center)
putdocx text ("Statistiques Descriptives par Parcours")

** Tableau pour variables continues
putdocx paragraph
putdocx text ("Variables continues")

local ncont : word count `vars_cont'
putdocx table cont = (`=`ncont'+5', 9), border(all, single) width(100%)

** En-tête du tableau
putdocx table cont(1,1) = ("Variable")
putdocx table cont(1,2) = ("LAS"), halign(center) 
putdocx table cont(1,4) = ("PACES"), halign(center) 
putdocx table cont(1,6) = ("PASS"), halign(center) 
putdocx table cont(1,8) = ("Passerelle"), halign(center) 

* Sous-en-têtes
putdocx table cont(2,2) = ("Moyenne"), bold halign(center)
putdocx table cont(2,3) = ("Écart-type"), bold halign(center)
putdocx table cont(2,4) = ("Moyenne"), bold halign(center)
putdocx table cont(2,5) = ("Écart-type"), bold halign(center)
putdocx table cont(2,6) = ("Moyenne"), bold halign(center)
putdocx table cont(2,7) = ("Écart-type"), bold halign(center)
putdocx table cont(2,8) = ("Moyenne"), bold halign(center)
putdocx table cont(2,9) = ("Écart-type"), bold halign(center)

** Remplissage des données
local row = 3
foreach var of local vars_cont {
    * LAS (parcour=1)
    quietly summarize `var' if parcour == 1
    local m1 = cond(r(N)>0, string(r(mean), "%9.2f"), "NA")
    local sd1 = cond(r(N)>0, string(r(sd), "%9.2f"), "NA")
    local N1 = r(N)
    
    * PACES (parcour=2)
    quietly summarize `var' if parcour == 2
    local m2 = cond(r(N)>0, string(r(mean), "%9.2f"), "NA")
    local sd2 = cond(r(N)>0, string(r(sd), "%9.2f"), "NA")
    local N2 = r(N)
    
    * PASS (parcour=3)
    quietly summarize `var' if parcour == 3
    local m3 = cond(r(N)>0, string(r(mean), "%9.2f"), "NA")
    local sd3 = cond(r(N)>0, string(r(sd), "%9.2f"), "NA")
    local N3 = r(N)
    
    * Passerelle (parcour=4)
    quietly summarize `var' if parcour == 4
    local m4 = cond(r(N)>0, string(r(mean), "%9.2f"), "NA")
    local sd4 = cond(r(N)>0, string(r(sd), "%9.2f"), "NA")
    local N4 = r(N)
    
    putdocx table cont(`row',1) = ("`var'")
    putdocx table cont(`row',2) = ("`m1'"), halign(center)
    putdocx table cont(`row',3) = ("`sd1'"), halign(center)
    putdocx table cont(`row',4) = ("`m2'"), halign(center)
    putdocx table cont(`row',5) = ("`sd2'"), halign(center)
    putdocx table cont(`row',6) = ("`m3'"), halign(center)
    putdocx table cont(`row',7) = ("`sd3'"), halign(center)
    putdocx table cont(`row',8) = ("`m4'"), halign(center)
    putdocx table cont(`row',9) = ("`sd4'"), halign(center)
    
    local ++row
}

** Lignes des effectifs
putdocx table cont(`row',1) = ("Effectifs"), bold
putdocx table cont(`row',2) = ("`N1'"), halign(center) 
putdocx table cont(`row',4) = ("`N2'"), halign(center) 
putdocx table cont(`row',6) = ("`N3'"), halign(center) 
putdocx table cont(`row',8) = ("`N4'"), halign(center) 

** Tableau pour variables binaires
putdocx paragraph
putdocx text ("Variables binaires")

local nbin : word count `vars_bin'
putdocx table bin = (`=`nbin'+5', 9), border(all, single) width(100%)

** En-tête du tableau
putdocx table bin(1,1) = ("Variable")
putdocx table bin(1,2) = ("LAS"), halign(center) 
putdocx table bin(1,4) = ("PACES"), halign(center) 
putdocx table bin(1,6) = ("PASS"), halign(center) 
putdocx table bin(1,8) = ("Passerelle"), halign(center) 

* Sous-en-têtes
putdocx table bin(2,2) = ("Proportion"), bold halign(center)
putdocx table bin(2,3) = ("Écart-type"), bold halign(center)
putdocx table bin(2,4) = ("Proportion"), bold halign(center)
putdocx table bin(2,5) = ("Écart-type"), bold halign(center)
putdocx table bin(2,6) = ("Proportion"), bold halign(center)
putdocx table bin(2,7) = ("Écart-type"), bold halign(center)
putdocx table bin(2,8) = ("Proportion"), bold halign(center)
putdocx table bin(2,9) = ("Écart-type"), bold halign(center)

** Remplissage des données
local row = 3
foreach var of local vars_bin {
    * LAS (parcour=1)
    quietly summarize `var' if parcour == 1
    local m1 = cond(r(N)>0, string(r(mean), "%9.2f"), "NA")
    local sd1 = cond(r(N)>0, string(r(sd), "%9.2f"), "NA")
    local N1 = r(N)
    
    * PACES (parcour=2)
    quietly summarize `var' if parcour == 2
    local m2 = cond(r(N)>0, string(r(mean), "%9.2f"), "NA")
    local sd2 = cond(r(N)>0, string(r(sd), "%9.2f"), "NA")
    local N2 = r(N)
    
    * PASS (parcour=3)
    quietly summarize `var' if parcour == 3
    local m3 = cond(r(N)>0, string(r(mean), "%9.2f"), "NA")
    local sd3 = cond(r(N)>0, string(r(sd), "%9.2f"), "NA")
    local N3 = r(N)
    
    * Passerelle (parcour=4)
    quietly summarize `var' if parcour == 4
    local m4 = cond(r(N)>0, string(r(mean), "%9.2f"), "NA")
    local sd4 = cond(r(N)>0, string(r(sd), "%9.2f"), "NA")
    local N4 = r(N)
    
    putdocx table bin(`row',1) = ("`var'")
    putdocx table bin(`row',2) = ("`m1'"), halign(center)
    putdocx table bin(`row',3) = ("`sd1'"), halign(center)
    putdocx table bin(`row',4) = ("`m2'"), halign(center)
    putdocx table bin(`row',5) = ("`sd2'"), halign(center)
    putdocx table bin(`row',6) = ("`m3'"), halign(center)
    putdocx table bin(`row',7) = ("`sd3'"), halign(center)
    putdocx table bin(`row',8) = ("`m4'"), halign(center)
    putdocx table bin(`row',9) = ("`sd4'"), halign(center)
    
    local ++row
}

** Lignes des effectifs
putdocx table bin(`row',1) = ("Effectifs"), bold
putdocx table bin(`row',2) = ("`N1'"), halign(center) 
putdocx table bin(`row',4) = ("`N2'"), halign(center) 
putdocx table bin(`row',6) = ("`N3'"), halign(center) 
putdocx table bin(`row',8) = ("`N4'"), halign(center) 

** Sauvegarde du document
putdocx save "Statistiques_Descriptives_par_Parcours.docx", replace


* S'assurer que la variable formation est bien catégorielle
* (ex : 1 = LAS, 2 = PACES, 3 = PASS, 4 = Passerelle)

tabulate parcour

* Calcul des moyennes et écarts-types par formation pour chaque variable
tabstat JSE PT CC SPS SVO_angle, by(parcour) statistics(mean sd) columns(statistics) format(%9.2f)




* Vérifier la variable catégorielle
tabulate parcour

* Créer un nouveau document Word
putdocx begin

* Ajouter un titre
putdocx paragraph, style(Heading1)
putdocx text ("Tableau descriptif des moyennes et écarts-types par parcours")

* Ajouter un tableau avec les moyennes et écarts-types
quietly tabstat JSE PT CC SPS SVO_angle, by(parcour) statistics(mean sd) columns(statistics) format(%9.2f)

* Enregistrer le tableau de résultats dans une matrice
matrix T = r(StatTotal)
matrix list T

* Exporter directement la sortie de tabstat dans Word
putdocx paragraph
putdocx text ("Moyennes et écarts-types par parcours :"), bold

putdocx table tab1 = r(StatTotal), ///
    title("Descriptif par parcours") 

* Enregistrer le fichier Word
putdocx save "resultats_tableau.docx", replace



