;;;======================================================
;;;     Expert System
;;;
;;;     This expert system will help you choose laptop
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-laptop-view ""
   (not (powerful ?))
   (not (laptop ?))
   =>
   (assert (powerful (yes-or-no-p "Do you need a powerful laptop (yes/no)? "))))
   

(defrule determine-laptop-purpose ""
   (powerful yes)
   (not (laptop ?))
   =>
   (assert (purpose 
           (ask-question "What laptop do you need (game/work/office)? "
                          game work office))))

(defrule determine-purpose-budget ""
   (powerful no)
   (not (laptop ?))   
   =>
   (assert (purpose-budget
	   (ask-question "What is a budget laptop for (study/movie/other)? "
                          study movie other))))

(defrule determine-cpu ""
   (purpose game)
   (not (laptop ?))
   =>
   (assert (laptop-cpu (yes-or-no-p "Do you need a laptop on Intel processor (yes/no)? "))))

(defrule determine-operating-system ""
   (purpose work)
   (not (laptop ?))
   =>
   (assert (system
           (ask-question "What operating system do you need (mac/windows/other)? "
                          mac windows other))))
   
(defrule determine-touch-bar ""
   (system mac)
   (not (laptop ?))
   =>
   (assert (touch-b (yes-or-no-p "Do i need a touch-bar (yes/no)? "))))

(defrule determine-laptop-office ""
   (purpose office)
   (not (laptop ?))
   =>
   (assert (ssd (yes-or-no-p "Need ssd (yes/no)? "))))

(defrule determine-videocard-dis ""
   (purpose-budget study)
   (not (laptop ?))
   =>
   (assert (videocard
               (yes-or-no-p "Do i need a discrete graphics card (yes/no)? "))))

(defrule determine-backlight-keyboard ""
   (videocard yes)
   (not (laptop ?))
   =>
   (assert (backlight
               (yes-or-no-p "Do i need a keyboard backlight (yes/no)? "))))

(defrule determine-body ""
   (videocard no)
   (not (laptop ?))
   =>
   (assert (case
               (yes-or-no-p "Need a metal case (yes/no)? "))))

(defrule determine-type-matrix ""
   (purpose-budget movie)
   (not (laptop ?))
   =>
   (assert (matrix
               (yes-or-no-p "Need an ips matrix (yes/no)? "))))

(defrule determine-screen-size ""
   (purpose-budget other)
   (not (laptop ?))
   =>
   (assert (screen
           (ask-question "What screen size is needed? (small/normal/big)? "
                          small normal big))))


;;;****************
;;;* REPAIR RULES *
;;;****************

(defrule gaming-intel ""
   (laptop-cpu yes)
   (not (laptop ?))
   =>
   (assert (repair "MSI GS66 Stealsh")))

(defrule gaming-amd ""
   (laptop-cpu no)
   (not (laptop ?))
   =>
   (assert (repair "HP OMEN 15-ENOO42UR")))

(defrule availability-ssd ""
   (ssd yes)
   (not (laptop ?))
   =>
   (assert (repair "HP ProBook 450 G7")))

(defrule no-ssd ""
   (ssd no)
   (not (laptop ?))
   =>
   (assert (repair "LENOVO IdeaPad S340")))

(defrule availability-touch ""
   (touch-b yes)
   (not (laptop ?))
   =>
   (assert (repair "MacBook Pro M1")))

(defrule no-touch ""
   (touch-b no)
   (not (laptop ?))
   =>
   (assert (laptop "MacBook Air")))

(defrule windows ""
   (system system)
   (not (laptop ?))
   =>
   (assert (repair "ASUS ZENBOOK 15 UX533FD")))

(defrule other-os ""
   (system other)
   (not (laptop ?))
   =>
   (assert (repair "Dell G5 15 5590")))

(defrule availability-backlight ""
   (backlight yes)
   (not (laptop ?))
   =>
   (assert (repair "Acer Aspire 5")))

(defrule no-backlight ""
   (backlight no)
   (not (laptop ?))
   =>
   (assert (repair "HP 250 G7")))

(defrule availability-metal ""
   (case yes)
   (not (laptop ?))
   =>
   (assert (repair "Acer Aspire A515")))

(defrule no-backlight ""
   (case no)
   (not (laptop ?))
   =>
   (assert (repair "Haier U1500HD")))

(defrule availability-ips ""
   (matrix yes)
   (not (laptop ?))
   =>
   (assert (repair "Asus VivoBook")))

(defrule no-ips ""
   (matrix no)
   (not (laptop ?))
   =>
   (assert (repair "Acer Aspire 1")))

(defrule netbook ""
   (screen small)
   (not (laptop ?))
   =>
   (assert (repair "Digma EVE 10 C301")))

(defrule laptop-normal ""
   (screen normal)
   (not (laptop ?))
   =>
   (assert (repair "Dell Inspiron")))

(defrule laptop-big ""
   (screen big)
   (not (laptop ?))
   =>
   (assert (repair "Acer Aspire 3 A317-32")))


;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Expert system for laptop selection")
  (printout t crlf crlf))

(defrule print-repair ""
  (declare (salience 10))
  (repair ?item)
  =>
  (printout t crlf crlf)
  (printout t "Proposed laptop:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))

