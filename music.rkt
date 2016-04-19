#lang racket
(require "combat.rkt")
(provide (all-defined-out))
(require rsound)
(require 2htdp/image)
(require 2htdp/universe)


;; - combat
;; - dungeon
;; - store
;; - image (splash screen/end screen)

;; Given a WAV file (PCM, 16-bit)
;; 1. read with rs-read
;; 2. IF you want to fade as part of looping,
;;    use rsound->signal/left (or /right) and then fader

;; dungeon
(define dsong (rs-read "Neverending Overture.wav"))

;; store
(define ssong (rs-read "Search.wav"))

;; splash
(define splashsong (rs-read "Prologue.wav"))

;;combat
(define csong (rs-read "Objection!.wav"))

;; dead
(define deadsong (rs-read "Jailers Elegy.wav"))


(define dungeon-music (make-pstream #:buffer-time 0.2))
(define store-music (make-pstream #:buffer-time 0.2))
(define splash-music (make-pstream #:buffer-time 0.2))
(define combat-music (make-pstream #:buffer-time 0.2))
(define dead-music (make-pstream #:buffer-time 0.2))

(define SDIRECTORY (list dungeon-music
                         store-music
                         splash-music
                         combat-music
                         dead-music))

(define (play-rsound-loop ps rs)
  (pstream-play ps rs)
  (begin (pstream-queue-callback ps
                                 (lambda () (play-rsound-loop ps rs))
                                 (+ (pstream-current-frame ps) (rs-frames rs)))
         ps))

(define (start-all)
  (play-rsound-loop dungeon-music dsong)
  (play-rsound-loop store-music ssong)
  (play-rsound-loop splash-music splashsong)
  (play-rsound-loop combat-music csong)
  (play-rsound-loop dead-music deadsong))

(define (silence-all) (silence SDIRECTORY))

(define (silence l)
  (cond
    [(empty? (rest l)) (pstream-set-volume! (first l) 0)]
    [else (pstream-set-volume! (first l) 0)
          (silence (rest l))]))

(define (hear p) (pstream-set-volume! p .2))

(define (start-music) (start-all) (silence-all) (hear splash-music))

(define (superset p) (silence-all) (hear p))



