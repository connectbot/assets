(define (localize-subheading text font input-file output-file)
  (gimp-context-set-foreground '(255 255 255))
  (let* ((img (car (gimp-file-load RUN-NONINTERACTIVE input-file input-file)))
         (textlayer (car (gimp-text-fontname img -1
                                             0 0
                                             text
                                             0
                                             TRUE
                                             51 PIXELS
                                             font))))
    (gimp-text-layer-set-justification textlayer TEXT-JUSTIFY-CENTER)
    (gimp-layer-translate textlayer 406 260)
    (gimp-text-layer-resize textlayer 556 206)
    ; Create the drop text shadow laye)r
    (let* ((shadowlayer (car (gimp-layer-copy textlayer TRUE))))
      (gimp-image-add-layer img shadowlayer 3)
      (gimp-layer-resize-to-image-size shadowlayer)
      (gimp-layer-set-opacity shadowlayer 56)
      (gimp-context-set-foreground '(0 0 0))
      (gimp-image-select-item img CHANNEL-OP-ADD shadowlayer)
      (gimp-selection-grow img 20)
      (gimp-selection-feather img 15)
      (gimp-bucket-fill shadowlayer FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0))
    ; Flatten the image and write it out
    (let* ((result (car (gimp-image-flatten img))))
      (gimp-file-save RUN-NONINTERACTIVE img result output-file output-file))))
