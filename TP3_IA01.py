# -*- coding: utf-8 -*-
"""
Created on Thu Jan  6 12:48:24 2022

@author: ninic
"""


chemin = []
def question_motif ():
    motif = int(input("Bonjour quel est le motif de votre demande ?\n"
                      "Vous avez le choix entre\n" 
                      "1: achat d'un ordinateur\n" 
                      "2: passage du permis\n"
                      "3: un aménagement\n" 
                      "4: une rénovation\n"
                      "5: pour de la décoration\n\n"
                      "Entrer le numéro correspondant à votre motif: "))
    if motif == 1:
        bdf.append("motif = ordinateur")
    if motif == 2:
        bdf.append("motif = permis")
    if motif == 3:
        bdf.append("motif = amenagement")
    if motif == 4:
        bdf.append("motif = renovation")
    if motif == 5:
        bdf.append("motif = decoration")
        
def question_montant ():
    montant = float(input("Quel est le montant que vous désirez obtenir: "))
    if  montant < 3000 :
        bdf.append("montant < 3000")
    elif   montant >= 3000:
        bdf.append("montant >= 3000")
    
    
def question_revenu ():
    revenu = float(input("Entrer vos revenus mensuels : "))
    if revenu > 500:
        bdf.append("revenu > 500")
    if revenu <500:
        bdf.append("revenu < 500")
    if revenu > 2430:
        bdf.append("revenu > 2430")
    if revenu < 2430:
        bdf.append("revenu < 2430")
    if revenu > 208:
        bdf.append("revenu > 208")
    if revenu < 208:
        bdf.append("revenu < 208")
    
    
def numRegle (R):
    return R[0]
def ccl_regle (R):
    return R[2]

def premisse (R):
    return R[1]    

bdf = ["diplome_vise = ingenieur"]
def premisse_respecter1 (bdf,bdr):
    for i in bdr:                 
        for j in bdf:
            if j == premisse(i):
                bdf.append(ccl_regle(i))
                chemin.append(numRegle(i))
                break
    return bdf
  
def premisse_respecter2 (bdf,bdr):
    fait = (bdf[2],bdf[3])           #fait est la premisse permettent de savoir crédit qui nous sera proposé
    for i in bdr:
        if fait == premisse(i):
            bdf.append(ccl_regle(i))
            chemin.append(numRegle(i))
    return bdf

def premisse_respecter3 (bdf,bdr):
    c1 = (bdf[4],bdf[5])         #c1, c2 et c3 sont les 3 premisses qui vérifie si le credit est possible
    c2 = (bdf[4],bdf[6])
    c3 = (bdf[4],bdf[7])
    for i in bdr:                #on parcours la base de règle pour vérifier quel règle qu'une des prémisses présente dans la base de fait vérifie
        if c1 == premisse(i) or c2 == premisse(i) or c3 == premisse(i):
            bdf.append(ccl_regle(i))
            chemin.append(numRegle(i))
            break
    return bdf

def bilan (bdf):
    for i in bdf:
        if i == "possible = non":
            bdf.append(ccl_regle(bdr[24]))
            print("Dû à vos revenus vous aurez besoin d'un garant")
        elif i == "possible = oui":
            for i in bdf:
                if i == "credit = credit_renouvelable1" or i == "credit = credit_renouvelable2" or i == "credit = pret_personnel1" or i == "credit = pret_personnel2":
                    print("Vous pouvez bénificier du",i[8:])
    

#def main():
    
    
bdr = [["R1",("diplome_vise = ingenieur"),"motif = question"],
    ["R2",("motif = ordinateur"),"type = consommation"],
    ["R3",("motif = permis"),"type = consommation"],
    ["R4", ("motif = amenagement"), "type = travaux"],
    ["R5", ("motif = renovation"), "type = travaux"],
    ["R6", ("motif = decoration"), "type = travaux"],
    ["R7", ("type = consommation"), "montant = question"],
    ["R8", ("type = travaux"), "montant = question"],
    
    ["R9",	("type = consommation","montant < 3000"),"credit = credit_renouvelable1"],
    
    ["R10", ("type = travaux","montant < 3000"),"credit = credit_renouvelable2"],
    
    ["R11", ("type = consommation","montant >= 3000"), "credit = pret_personnel1"],
    
    ["R12", ("type = travaux","montant >= 3000"), "credit = pret_personnel2"],
    
    ["R13", ("credit = credit_renouvelable1"), "revenu = question"],
    
    ["R14", ("credit = credit_renouvelable2"), "revenu = question"],
    
    ["R15", ("credit = pret_personnel1"), "revenu = question"],
    
    ["R16", ("credit = pret_personnel2"), "revenu = question"],
    
    ["R17", ("credit = pret_personnel1","revenu > 500"), "possible = oui"],
    
    ["R18", ("credit = pret_personnel2","revenu > 2430"), "possible = oui"],
    
    ["R19", ("credit = credit_renouvelable1","revenu > 208"), "possible = oui"],
    
    ["R20", ("credit = credit_renouvelable2","revenu > 2430"),"possible = oui"],
    
    ["R21",("credit = pret_personnel1","revenu < 500"),
    	"possible = non"],
    
    
    ["R22",("credit = pret_personnel2","revenu < 2430"),
    "possible = non"],
    
    ["R23", ("credit = credit_renouvelable1","revenu < 208"),	
    "possible = non"],
    
    ["R24", ("credit = credit_renouvelable2","revenu < 2430"),"possible = non"],
    
    ["R25", ("possible = non"),"complement=garant"]]
    
def main():
    if premisse_respecter1(bdf, bdr)[1] == "motif = question" :
        del(bdf[1])                 #supprime "motif = question" pour le remplacer
        question_motif()
    premisse_respecter1(bdf, bdr)
    del(chemin[1])               #supprime la règle 1 qui est de nouveau ajouté au chemin
    del(bdf[2])                  #supprime "motif = question" qui est de nouveau ajouté
    for i in bdf:
        if i == "montant = question":
            del(bdf[-1])            #supprime "montant = question" pour le remplacer
            question_montant()
    premisse_respecter2(bdf, bdr)
    if premisse_respecter1(bdf, bdr)[-1] == "revenu = question":
        del(bdf[5:9])               #supprime "revenu = question" pour le remplacer
        question_revenu()           #et les résultats des règles déjà évaluées qui le sont de nouveaux dans la base de fait
    del(chemin[4:7])                #supprime les noms des règles déjà évaluées qui sont rajoutées de nouveaux dans le chemin parcouru
    premisse_respecter3(bdf, bdr)
    bilan(bdf)
    print("Chemin parcouru: ",chemin)
    
    


  


