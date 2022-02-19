
;; TP3 ;;


;;;;;;;;;;;;;;; base de fait ;;;;;;;;;;;;;;;


(setq BF '( (diplome_vise ingenieur)))


;;;;;;;;;;;;;;; base de règle ;;;;;;;;;;;;;;;


(setq BR '( 

(R1	((equal diplome_vise ingenieur))	(motif question))
(R2	((equal motif ordinateur))		(type consommation))
(R3 	((equal motif permis))			(type consommation))
(R4 	((equal motif amenagement)) 	(type travaux))
(R5  	((equal motif renovation)) 		(type travaux))
(R6  	((equal motif decoration)) 		(type travaux))
(R7 	((equal type travaux))			(montant question))
(R8 	((equal type consommation))			(montant question))

(R9	((eq type consommation) (< montant 3000 ))		(credit credit_renouvelable1))

(R10	((equal type travaux) (< montant 3000))		(credit credit_renouvelable2))

(R11	((equal type consommation) (>= montant 3000))	   (credit pret_personnel1))

(R12 	((equal type travaux) (>= montant 3000)) 		(credit credit pret_personnel2))


(R13 	((equal credit credit_renouvelable1)) 		(revenu question))
(R14 	((equal credit credit_renouvelable2)) 		(revenu question))
(R15 	((equal credit pret_personnel1)) 		(revenu question))
(R16 	((equal credit pret_personnel2)) 		(revenu question))


(R17	((equal credit pret_personnel1) (>  revenu 500))		(possible? oui))
(R18	((equal credit pret_personnel2) (>  revenu 2430))		(possible? oui)) 

(R19  	((equal credit credit_renouvelable1) (> revenu 208)) 	(possible? oui))

(R20 	((equal credit credit_renouvelable2) (> revenu 2430))		(possible? oui))

(R21 	((equal credit credit_personnel1) (> montant (* 0.4 revenu)))	(possible? non))


(R22	((equal credit credit_personnel2) (> montant (* 0.4 revenu))) 	(possible? non))

(R23 	((equal credit credit_renouvelable1) (> montant (* 0.4 revenu))) 	(possible? non))

(R24 	((equal credit credit_renouvelable2) (> montant (* 0.4 revenu))) 	(possible? non))

(R25 	((equal possible? non))	 (complement garant))
))

     

;;;;;;;;;;;;;;; Fonctions de service ;;;;;;;;;;;;;;;

;; fonction retourne la liste avec le nom des règles
(defun nom_regles(list)
  (if list
      (cons (car (car list)) (nom_regles(cdr list)))))


;; (nom_regles br) -> (R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 ...)
;; (nom_regles (cdr br)) -> (R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 ...)


(defun premisse(r)   ;retourne la liste des premisses
  (cadr r) )


; (premisse (caddr br))
; (premisse (cadr br))

(defun conclusion(r)   ; retourne la conclusion d'une règle sous la forme (var val)
  (caddr r) )

; (conclusion (caddr br))
; (conclusion (cadr br))


;; la fonction affiche du texte differemment selon la variable en paramètre
(defun afficher_texte(var)
  (let* ((motifs '(amenagement renovation decoration ordinateur permis)))
    (cond 
     ((equal var 'motif) (format t " ~% motifs acceptés: ~s" motifs))
     ((equal var 'revenu) (format t " ~% revenu doit être >0 "))
     ((equal var 'montant) (format t " ~% montant doit être >0 et <=35000  "))
     )))


;; la fonction permet d'entrer au clavier la valeur de la variable montant
(defun montant(fait bf br)
  (if (equal (cadr fait) 'question)
      (if (equal (car fait) 'montant)
          (progn
            (afficher_texte (car fait))
            (format t "~% Entrez la valeur de ~s : " (car fait))
            (setq a (read))
            (if (and (> a 0) (<= a 35000))  
                ;on ne peut pas entrer de valeur negative
                ;on verifie que le pret est <=35000 seulement dans le cas d'un montant
                (push (list (car fait) a) bf)
              (montant fait bf br)
              )
            )
        )  
    (format t " ERREUR!! ~%")
    )
  )

;; (montant '(montant 5000) bf br)
;; (montant '(motif 5000) bf br)
;; (montant '(montant question) bf br)


;; la fonction permet de questionner l'utilisateur quant à la valeur d'une variable
;; pour vérifier le caractère demandable il faut que la variable est comme valeur question
(defun question(fait bf br)
  ;; fait de la forme: (variable valeur)
  (let ( (ajout nil) (verif nil))
  (if (equal (cadr fait) 'question)    ;; on questionne les variables de valeur question
      (progn
        (afficher_texte (car fait))
        (format t "~% Entrez la valeur de ~s : " (car fait))
        (setq ajout (read))
        ;;(print ajout)

        (dolist (r br 'fin)
          ;;(print (list (car fait) ajout))
          ;;(print (fait_declencheur? (list (car fait) ajout) r))
              (if (fait_declencheur? (list (car fait) ajout) r)
                  (setq verif t)
                )) 
        ;;(print verif)
        (if verif
            (push (list (car fait) ajout) bf)    
          (question fait bf br)
          )
        ) 
    (format t " ERREUR!! ~%")
    )   
    )
  )
    
    
;; (question '(montant 5000) bf br)
;; (question '(motif voyage) bf br)
;; (question '(motif question) bf br)
;; (question '(montant question) bf br)
;; (question '(revenu question) bf br)


;; vérifie que le fait se trouve dans la bf
(defun est_dans_bf(fait bf)   
  ;;un fait est de la forme: (variable valeur)
    (let ((valeur (cadr (assoc (car fait) bf))))
      (equal valeur (cadr fait))) )
  


;; (est_dans_bf '(diplome_vise ingenieur) bf)
;; (est_dans_bf '(diplome_vise inge) bf)
;; (est_dans_bf '(montant 500) bf)
;; (est_dans_bf '(motif ordinateur) bf)


;; si une variable devant être renseigné par l'utilisateur se trouve dans la BF
;; si elle présente c'est que l'utilisateur a déja renseigné sa valeur
(defun question_est_dans_bf(variable bf) 
  (not (equal (assoc variable bf) nil)) )

;; (question_est_dans_bf 'diplome_vise bf)
;; (question_est_dans_bf 'montant bf)



;; retourne les règles concluant sur le but
(defun regles_candidates(fait br)  
  ;; but de la forme: (variable valeur)
  (if br
      (progn
        
        ;; il faut verifier que la conclusion de la règle
        ;; soit égale à notre but
        (if (equal (conclusion (car br)) fait)
            ;; on ajoute à la liste
            (cons (car br) (regles_candidates fait (cdr br)))
          (regles_candidates fait (cdr br)) ))) )



;; (setq r9 (car (regles_candidates '(credit credit_renouvelable1) br)))
;; (regles_candidates '(type travaux) br)
;; (regles_candidates '(credit credit_renouvelable2) br)


;; vérifie si le fait en paramètre permet de conclure la règle
(defun fait_declencheur?(fait r)
  ;; fait de la forme (var val)
  ;; premisse sous format (relation var val)
  (let* ( (premiss (premisse r)) (verif nil) )  
    (dolist (p premiss verif)
      ;; on agit uniquement avec la premisse concerné par le fait
      (if (equal (cadr p) (car fait))
          ;; si les valeurs sont des nombres
          (if (or (numberp (caddr p)) (numberp (cadr fait)))
              (progn
                (setq express (list (car p) (cadr fait) (caddr p) ))
                ;;(print express)
                (if (eval express) 
                    (setq verif t)
                  )
                )
            ;; si les valeurs ne sont pas des nombres (plutot des chaines de caractères)
            ;; on verifie juste l'égalité entre valeur du fait en parametre
            ;; et valeur du fait de la premisse
            (progn 
              (if (equal (cadr fait) (caddr p))
                  (setq verif t)
                )
              )
            )
        ))))


;; (setq r7 (car (regles_candidates '(montant question) br)))
;; (setq r13 (car (regles_candidates '(revenu question) br)))
;; (setq r10 (car (regles_candidates '(credit credit_renouvelable2) br)))
;; (setq r9 (car (regles_candidates '(credit credit_renouvelable1) br)))
;; (fait_declencheur? '(type travaux) r10)
;; (fait_declencheur? '(montant 6545) r9)
;; (fait_declencheur? '(montant 650) r10)
;; (fait_declencheur? '(credit CREDIT_RENOUVELABLE1) r13)
  
  
;; incomplet
(defun chainage-arriere (but bf br chemin)
  ;; but de la forme (var val)
  (if (est_dans_bf but bf) 
      (progn 
       ;; (format t "~%   But : ~A" but)
       ;; (setq chemin (push but chemin))
        ;;(print chemin)
        )
    (progn
      (let* ((regles (regles_candidates but br)))
        (format t "~% ~s avec :  ~s" but (nom_regles regles))
        (dolist (r regles 'fin)
          (let ((premisses (premisse r)))
            (format t "~% ~t Conditions de ~s :  ~A~%" (car r) premisses)
            (dolist (p premisses 'fin) 
              
              (if (est_dans_bf (cdr p) bf)
                  (progn
                    
            (setq bf (push (conclusion r) bf))
               
            ;; sinon on regarde si c'est une valeur 
        ;;qu'on doit nous même renseigner
        
        (progn   
          (if (regles_candidates (list (cadr p) 'question) br)
              
              ;; on verifie si une valeur a déja été entrée  
              ;; si c'est le cas alors la valeur declenche une regle
              
              (progn
                (if (question_est_dans_bf (cadr p) bf)  
                    
                    ;; si c'est la regle déclenchée on ajoute sa conclusion à la bf
                    (if (fait_declencheur? (assoc (cadr p) bf) r)                   
                        (setq bf (push (conclusion r) bf)))
     
                  ;; si on a jamais renseigné de valeur alors              
                  ;; on renseigne la valeur de la variable et on l'ajoute dans bf  
                  (setq bf (question (list (cadr p) 'question) bf br))))
            
            )))

                (chainage-arriere (cdr p) bf br chemin)) ))))))
  (format t "~% chemin = ~s" chemin))


;; (chainage-arriere '(possible? oui) bf br nil)


;; incomplet
(defun chainage_avant (bf br chemin)
  ;; but de la forme (var val)
  (let* ((ajout nil) (elem_bf (car bf)))
    
    (print elem_bf)
    (if (assoc 'possible? bf)
        (print chemin)
      
      (progn
    (dolist (r br 'fin)
      (if (fait_declencheur? elem_bf r)
          (progn 
            (format t "~% avec ~s -> on obtient ~s " elem_bf (conclusion r))
            
            (if (equal 'question (cadr (conclusion r)))
                (progn
                  (if (equal 'montant (car (conclusion r)))
                      (progn 
                        (setq bf (montant (conclusion r) bf br))
                        (setq chemin (push elem_bf chemin)))
                    (progn
                      (setq bf (question (conclusion r) bf br))
                      (setq chemin (push elem_bf chemin))) ))
              (progn  
                (setq bf (question (conclusion r) bf br))
                (setq chemin (push elem_bf chemin))    ) ) ) ) ))
      (chainage_avant bf br chemin))
    
    (print chemin))
  (print chemin) (print bf) )
  