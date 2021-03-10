library(shiny)
library(shinydashboard)
library(reader)

####################################################################
#                                HEADER
####################################################################
header<-dashboardHeader(title="MIAS")
####################################################################
#                                SIDEBAR
####################################################################
sidebar<-dashboardSidebar(
    sidebarMenu(
        menuItem(
            "Información",
            tabName="tInfo",
            icon=icon("bookmark")
        ),
        menuItem(
            "Aplicación",
            tabName="tApp",
            icon=icon("lightbulb"))
    )
)
####################################################################
#                                BODY
####################################################################
body<-dashboardBody(
    tabItems(
        tabItem(
            tabName="tInfo",
            h1("Información sobre este proyecto"),
            fluidRow(
                box(
                    title=tagList(shiny::icon("school"),
                                  "Universidad del Caribe"),
                    status="primary",
                    solidHeader=T,
                    width=12,
                    background="navy",
                    h4("El siguienre proyecto ha sido elaborado por alumnos
                    de la Universidad del Caribe cursando la asignatura de
                    Herramientas para la Gestión de Grandes Volúmenes de
                    Datos")
                )
            ),
            fluidRow(
                box(
                    title=tagList(shiny::icon("people-carry"),
                                  "DOMEN"),
                    status="success",
                    solidHeader=T,
                    width=4,
                    h4("El equipo de trabajo está integrado por:
                       Rafael Lagunas Guitron y Magno Jahfet Canul
                       Contreras. Bajo la enseñanza del Dr. Jairo
                       Arturo Ayala Godoy")
                ),
                box(
                    title=tagList(shiny::icon("database"),
                                  "Datos"),
                    status="warning",
                    solidHeader=T,
                    width=4,
                    h4("Los datos son obtenidos desde una base de datos de
                       mamografías (http://peipa.essex.ac.uk/info/mias.html)")
                ),
                box(
                    title=tagList(shiny::icon("r-project"),
                                  "Proyecto"),
                    status="info",
                    solidHeader=T,
                    width=4,
                    h4("El proyecto busca principalmente practicar el
                    procesamiento de imágenes con una serie de pasos
                    de limpiezas que se realizarán cada semana")
                )
            ),
            tabBox(
                title=tagList(shiny::icon("lightbulb"),
                              "Aplicación"),
                width=12,
                tabPanel(tagList(shiny::icon("exclamation"),"Detalles"),
                         h4("Esta sección está dedicada para seleccionar
                            el ID de una mamografía y presentar la
                            imagen correspondiente y su información
                            obtenida de la base de datos")),
                tabPanel(tagList(shiny::icon("border-none"),"Fondo"),
                         h4("Para conseguir limpiar el fondo de las
                            imágenes realizamos 3 pasos: binarizamos la
                            imagen para detectar los objetos que la
                            componen, selecionamos el segmento de mayor
                            área blanca y generamos una nueva imagen a
                            manera de máscara, finalmente con dicha
                            máscara recuperamos los pixeles de la imagen
                            original en la zona deseada")),
                tabPanel(tagList(shiny::icon("code"),"Músculo"),
                         h4("Incoming...(16 de marzo)")),
                tabPanel(tagList(shiny::icon("code"),"Tejido"),
                         h4("Incoming...(23 de marzo)")),
                tabPanel(tagList(shiny::icon("code"),"Anormalidad"),
                         h4("Incoming...(15 de abril)")),
                tabPanel(tagList(shiny::icon("code"),"Severidad"),
                         h4("Incoming...(15 de abril)"))
            )
        ),
        tabItem(
            tabName="tApp",
            fluidRow(
                box(
                    title=tagList(shiny::icon("cog"),
                                  "Selecciona un ID"),
                    status="info",
                    solidHeader=T,
                    width=12,
                    #background="navy",
                    sliderInput(
                        "mdbid",
                        "Seleciona un ID",
                        min=1,
                        max=322,
                        value=1,
                        step=1,
                    ),
                    submitButton("Consultar")
                )
            ),
            fluidRow(
                h2("Detalles"),br(),
                box(
                    title=tagList(shiny::icon("camera"),
                                  title=textOutput("idname")),
                    status="primary",
                    solidHeader=T,
                    background="black",
                    imageOutput("mamografia0")
                ),
                infoBoxOutput("boxTejido"),
                infoBoxOutput("boxCAnomalia"),
                infoBoxOutput("boxSeveridad"),
                infoBoxOutput("boxXY"),
                infoBoxOutput("boxRadio")
            ),
            fluidRow(
                h2("Limpieza del fondo"),
                box(
                    title=tagList(shiny::icon("adjust"),
                                  title="1 | Imagen Binaria"),
                    status="primary",
                    solidHeader=T,
                    collapsible=T,
                    collapsed=F,
                    width=4,
                    height=330,
                    background="black",
                    imageOutput("imagenbinaria")
                ),
                box(
                    title=tagList(shiny::icon("grin-alt"),
                                  title="2 | Máscara"),
                    status="primary",
                    solidHeader=T,
                    collapsible=T,
                    collapsed=F,
                    width=4,
                    height=330,
                    background="black",
                    imageOutput("imagenmascara")
                ),
                box(
                    title=tagList(shiny::icon("award"),
                                  title="3 | Imagen sin fondo"),
                    status="primary",
                    solidHeader=T,
                    collapsible=T,
                    collapsed=F,
                    width=4,
                    height=330,
                    background="black",
                    imageOutput("sinfondo")
                )
            ),
            fluidRow(h2("Eliminación del músculo")),
            fluidRow(h2("Clasificación del Tejido")),
            fluidRow(h2("Tipo de anormalidad")),
            fluidRow(h2("Severidad de anormalidad"))
        )
    )
)
####################################################################
#                                UI
####################################################################
ui<-dashboardPage(header,sidebar,body,skin="purple")

####################################################################
#                                SERVER
####################################################################
server<-function(input,output){
    lineofid<-function(id){
        addnline=0
        if(id>5){addnline=1
            if(id>132){addnline=addnline+1
                if(id>144){addnline=addnline+1
                    if(id>223){addnline=addnline+1
                        if(id>226){addnline=addnline+2
                            if(id>239){addnline=addnline+1
                                if(id>249){addnline=addnline+1}
                            }
                        }
                    }
                }
            }
        }
        
        n.readLines("all-mias/Info.txt",header=F,n=1,skip=(102+id+addnline))
    }
    
    output$idname<-renderText({
        strsplit(lineofid(input$mdbid),split=" ")[[1]][1]
    })
    
    output$boxTejido<-renderInfoBox({
        infowords<-strsplit(lineofid(input$mdbid),split=" ")[[1]]
        v=NULL
        if(infowords[2]=="F"){
            v="Graso"
        }else{
            if(infowords[2]=="G"){
                v="Graso Glandular"
            }else{
                if(infowords[2]=="D"){
                    v="Denso Glandular"
                }
            }
        }
        infoBox("Tipo de Tejido",v,width=12,color="navy",
                fill=T,icon=icon("cloudsmith"))
    })
    
    output$boxCAnomalia<-renderInfoBox({
        infowords<-strsplit(lineofid(input$mdbid),split=" ")[[1]]
        v=NULL
        if(infowords[3]=="CALC"){
            v="Calcificación"
        }else{
            if(infowords[3]=="CIRC"){
                v="Circunscrito"
            }else{
                if(infowords[3]=="SPIC"){
                    v="Espiculadas"
                }else{
                    if(infowords[3]=="MISC"){
                        v="Mal definidas"
                    }else{
                        if(infowords[3]=="ARCH"){
                            v="Distorción arquitectónica"
                        }else{
                            if(infowords[3]=="ASYM"){
                                v="Asimetría"
                            }else{
                                if(infowords[3]=="NORM")
                                    v="Normal"
                            }
                        }
                    }
                }
            }
        }
        infoBox("Clase de Anomalía",v,width=12,color="blue",
                fill=T,icon=icon("book-medical"))
    })
    
    output$boxSeveridad<-renderInfoBox({
        infowords<-strsplit(lineofid(input$mdbid),split=" ")[[1]]
        v=NULL
        if(is.na(infowords[4])){
            v="Sin problema"
            c="green"
        }else{
            if(infowords[4]=="B"){
                v="Benigno"
                c="yellow"
            }else{
                if(infowords[4]=="M"){
                    v="Maligno"
                    c="red"
                }
            }
        }
        infoBox("Severidad de la anormalía",v,width=12,
                color=c,fill=T,icon=icon("biohazard"))
    })
    
    output$boxXY<-renderInfoBox({
        infowords<-strsplit(lineofid(input$mdbid),split=" ")[[1]]
        v=NULL
        if(is.na(infowords[5])||infowords[5]=="*NOTE"){
            v=" "
            c="olive"
            ff=F
        }else{
            v=paste0(infowords[5],",",infowords[6])
            c="aqua"
            ff=T
        }
        infoBox("Coordenadas",v,width=12,
                color=c,fill=ff,icon=icon("bahai"))
    })
    
    output$boxRadio<-renderInfoBox({
        infowords<-strsplit(lineofid(input$mdbid),split=" ")[[1]]
        v=NULL
        if(is.na(infowords[7])){
            v=" "
            c="olive"
            ff=F
        }else{
            v=infowords[7]
            c="teal"
            ff=T
        }
        infoBox("Radio",v,width=12,
                color=c,fill=ff,icon=icon("bullseye"))
    })
    
    output$mamografia0<-renderImage({
        infowords<-strsplit(lineofid(input$mdbid),split=" ")[[1]]
        path<-normalizePath(file.path('./all-mias',
                                      paste0(infowords[1],".png")))
        list(src=path,width=400,height=400)
    },deleteFile=F)
    
    output$imagenbinaria<-renderImage({
        infowords<-strsplit(lineofid(input$mdbid),split=" ")[[1]]
        path<-normalizePath(file.path('./fondo',
                                      paste0(infowords[1],"bin.png")))
        list(src=path,width=270,height=270)
    },deleteFile=F)
    
    output$imagenmascara<-renderImage({
        infowords<-strsplit(lineofid(input$mdbid),split=" ")[[1]]
        path<-normalizePath(file.path('./fondo',
                                      paste0(infowords[1],"mask.png")))
        list(src=path,width=270,height=270)
    },deleteFile=F)
    
    output$sinfondo<-renderImage({
        infowords<-strsplit(lineofid(input$mdbid),split=" ")[[1]]
        path<-normalizePath(file.path('./fondo',
                                      paste0(infowords[1],"cleaned.png")))
        list(src=path,width=270,height=270)
    },deleteFile=F)
}

shinyApp(ui, server)