# README

When building the project webpack failed to compile javascript with the following error:   
`error:0308010C:digital envelope routines::unsupported`

In order to make webpack work try: 
- set the variable in bash: `export NODE_OPTIONS=--openssl-legacy-provider`
- update npm packages with: `npm upgrade --save`
