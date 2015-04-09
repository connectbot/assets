(define (shadow-layer img orig-layer)
  (let* ((shadow-layer (car (gimp-layer-copy orig-layer TRUE))))
    (gimp-image-insert-layer img shadow-layer 0 -1)
    (gimp-image-lower-layer img shadow-layer)
    (gimp-layer-resize-to-image-size shadow-layer)
    (gimp-layer-set-opacity shadow-layer 56)
    (gimp-context-set-foreground '(0 0 0))
    (gimp-image-select-item img CHANNEL-OP-ADD shadow-layer)
    (gimp-selection-grow img 20)
    (gimp-selection-feather img 15)
    (gimp-bucket-fill shadow-layer FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)))
  
(define (create-text-layer img text px-size font x y width height)
  (let* (
    (layer (car (gimp-text-fontname img -1
                                    0 0
                                    text
                                    0
                                    TRUE
                                    px-size PIXELS
                                    font))))
    (gimp-text-layer-set-justification layer TEXT-JUSTIFY-CENTER)
    (gimp-text-layer-set-color layer '(255 255 255))
    (gimp-layer-translate layer x y)
    (gimp-text-layer-resize layer width height)
    (shadow-layer img layer)
  )
)

(define (localize-subheading subtitle font output-file)
  (let*
    ( 
      (img (car (gimp-file-load RUN-NONINTERACTIVE "assets/connectbot-promo-bg.png" "assets/connectbot-promo-bg.png")))
      (logo-layer (car (gimp-file-load-layer RUN-NONINTERACTIVE img "assets/connectbot-promo-logo.png")))
    )
    ; Adjust the logo
    (gimp-image-insert-layer img logo-layer 0 -1)
    (gimp-layer-translate logo-layer 80 (/ (- (car (gimp-drawable-height img)) (car (gimp-drawable-height logo-layer))) 2))
    (shadow-layer img logo-layer)
    (gimp-image-set-active-layer img logo-layer)

    ; Title
    (create-text-layer img "ConnectBot" 104 font 390 130 584 152)
    ; Subtitle
    (create-text-layer img subtitle 51 font 406 260 556 206)

    (let* ((result (car (gimp-image-flatten img))))
      (gimp-file-save RUN-NONINTERACTIVE img result output-file output-file))))
