;; extends

(content
    (Comment) @injection.language (#offset! @injection.language 0 5 0 -4)
    (CDSect
        (CDStart)
        (CData) @injection.content 
        (#set! "priority" 200)
        (#set! injection.combined)
    )
)
