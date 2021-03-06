# Define server logic required to draw a histogram
server <- function(input, output) {

########################################################  
  # K8
    
  ranges <- reactiveValues(x=NULL, y=NULL)
  ranges_comp <- reactiveValues(x=NULL, y=NULL)
    #first plot
    output$sawtooth <- renderPlot({

      points <- selected_points() %>% filter(dataset == "lens")
      plot_sawtooths(
        ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat), 
        ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat),
        ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon) %% 360,
        ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon) %% 360)+
      # plot_sawtooths(selected_points()$min_lat[2], # second entry is for lens
      #                selected_points()$max_lat[2],
      #                selected_points()$min_lon[2] %% 360,
      #                selected_points()$max_lon[2] %% 360
      #                )+
        coord_cartesian(xlim=ranges$x,ylim=ranges$y,expand=FALSE)+
        ggtitle(str_c("First selection: ",input$state))

    })
    
    # When a double-click happens, check if there's a brush on the plot.
    # If so, zoom to the brush bounds; if not, reset the zoom.
    observeEvent(input$sawtooth_dblclick, {
      brush <- input$sawtooth_brush
      if (!is.null(brush)) {
        ranges$x <- c(brush$xmin, brush$xmax)
        ranges$y <- c(brush$ymin, brush$ymax)
        
      } else {
        ranges$x <- NULL
        ranges$y <- NULL
      }
    })
    
    output$num_der <- renderPlot({
      points <- selected_points() %>% filter(dataset == "lens")
      plot_num_der(

        ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat), 
        ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat),
        ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon) %% 360,
        ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon) %% 360
        # selected_points()$min_lat[2], # second entry is for lens
        # selected_points()$max_lat[2],
        # selected_points()$min_lon[2] %% 360,
        # selected_points()$max_lon[2] %% 360
      )+
        ggtitle(str_c("First selection: ",input$state))

    })
    


    #second plot
    output$comp_sawtooth <- renderPlot({
      points <- selected_points_compare() %>% filter(dataset == "lens")
      plot_sawtooths(

        ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat), 
        ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat),
        ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon) %% 360,
        ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon) %% 360)+

        # selected_points_compare()$min_lat[2], # second entry is for lens
        # selected_points_compare()$max_lat[2],
        # selected_points_compare()$min_lon[2] %% 360,
        # selected_points_compare()$max_lon[2] %% 360
        # )+
         coord_cartesian(xlim=ranges_comp$x,ylim=ranges_comp$y,expand=FALSE)+
        ggtitle(str_c("Second selection: ",input$comparison_state))

    })
    
    # When a double-click happens, check if there's a brush on the plot.
    # If so, zoom to the brush bounds; if not, reset the zoom.
    observeEvent(input$sawtooth_comp_dblclick, {
      brush1 <- input$sawtooth_comp_brush
      if (!is.null(brush1)) {
        ranges_comp$x <- c(brush1$xmin, brush1$xmax)
        ranges_comp$y <- c(brush1$ymin, brush1$ymax)
        
      } else {
        ranges_comp$x <- NULL
        ranges_comp$y <- NULL
      }
    })
    
    output$comp_num_der <- renderPlot({
      points <- selected_points_compare() %>% filter(dataset == "lens")
      plot_num_der(
        ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat), 
        ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat),
        ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon) %% 360,
        ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon) %% 360)+
        ggtitle(str_c("Second selection: ",input$comparison_state))

    })
#######################################################################
    # # smither8
    output$ranges_smooth <- renderPlot({ 
      points <- selected_points() %>% filter(dataset == "lens")
      plot_ranges_smooth(
        ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat), 
        ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat),
        ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon) %% 360,
        ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon) %% 360)
    })
    
    output$comp_ranges_smooth <- renderPlot({ 
      points <- selected_points_compare() %>% filter(dataset == "lens")
      plot_ranges_smooth(
        ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat), 
        ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat),
        ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon) %% 360,
        ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon) %% 360)
    }
    )
    
    output$ranges_box <- renderPlot({ 
      points <- selected_points() %>% filter(dataset == "lens")
      plot_ranges_box(
        ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat), 
        ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat),
        ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon) %% 360,
        ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon) %% 360)
    })
    
    output$comp_ranges_box <- renderPlot({ 
      points <- selected_points_compare() %>% filter(dataset == "lens")
      plot_ranges_box(
        ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat), 
        ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat),
        ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon) %% 360,
        ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon) %% 360)
    }
    )
    
    
#########################################################################    
    ####################################################
    ## Sidebar selection maps 
    ####################################################
    #initialize zoom 
    zoom_val <- reactiveVal(0)  
    observeEvent(input$zoom_in,{
      new_value <- zoom_func(current_zoom = zoom_val(),
                             state = input$state,
                             type = -1)
      zoom_val(new_value)
    })
    observeEvent(input$zoom_out,{
      new_value <- zoom_func(current_zoom = zoom_val(),
                             state = input$state,
                             type = 1)
      zoom_val(new_value)
    })
    #reset the zoom button if state is changed or called to reset 
    observeEvent(c(input$state,input$reset),{
      zoom_val(0)
    })

    # reactive bounding values to use for filtering 
    zoom_map_bounds <- reactive({
      map_bounds(state = input$state, 
                 current_zoom = zoom_val())
    })
    
    output$point_selection_map <- renderPlot({
      plot_brushed_map(state = input$state,
                       current_zoom = zoom_val(),
                       bounding_box = zoom_map_bounds())
    })
    
    ####################################################
    # For second comparision map - 
    zoom_val_compare <- reactiveVal(0)  
    observeEvent(input$zoom_in2,{
      new_value <- zoom_func(current_zoom = zoom_val_compare(),
                             state = input$comparison_state,
                             type = -1)
      zoom_val_compare(new_value)
    })
    observeEvent(input$zoom_out2,{
      new_value <- zoom_func(current_zoom = zoom_val_compare(),
                             state = input$comparison_state,
                             type = 1)
      zoom_val_compare(new_value)
    })
    #reset the zoom button if state is changed or called to reset 
    observeEvent(c(input$comparison_state,input$reset2),{
      zoom_val_compare(0)
    })
    zoom_map_comparison_bounds <- reactive({
      map_bounds(state = input$comparison_state, 
                 current_zoom = zoom_val_compare())
    })
    output$comparison_point_selection_map <- renderPlot({
      plot_brushed_map(state = input$comparison_state,
                       current_zoom = zoom_val_compare(),
                       bounding_box = zoom_map_comparison_bounds())
    })
    
    ############################################################
    ##### Filter datasets based on brushed points selections 
    ############################################################
    
    selected_points <- eventReactive(input$go,{
      brushedPoints(location_points,
                    input$plot_brush,
                    xvar = "lon",yvar = "lat") %>% 
        group_by(dataset) %>% 
        summarize(min_lon = min(lon),
                  max_lon = max(lon),
                  min_lat = min(lat),
                  max_lat = max(lat))
    })
    selected_points_compare <- eventReactive(input$go,{
      brushedPoints(location_points,
                    input$plot_brush2,
                    xvar = "lon",yvar = "lat") %>% 
        group_by(dataset) %>% 
        summarize(min_lon = min(lon),
                  max_lon = max(lon),
                  min_lat = min(lat),
                  max_lat = max(lat))
    })
    
    is_empty <- eventReactive(input$go,{
      nrows <- selected_points() %>%
        select(min_lat) %>% 
        summarize(n = n()) %>%
        as.numeric()
      ifelse(nrows == 0, TRUE, FALSE)
    })
    
    is_comparison_empty <- eventReactive(c(input$comparison_checkbox,input$go),{
      if(!input$comparison_checkbox){return(TRUE)}
      nrows <- selected_points_compare() %>%
        select(min_lat) %>% 
        summarize(n = n()) %>%
        as.numeric()
      ifelse(nrows == 0, TRUE, FALSE)
    })
  

    ############################################################
    ##### Get reactive data for precipitation deviation plots
    ############################################################
    # Default dataset if no selectoin - also united states baseline average comparison
    us_deviation <- get_us_precip_deviation()
    
    selection1 <- eventReactive(input$go,{
      get_precip_deviation_data(selected_points(),
                                data_choice=paste("Selection 1 - ", input$state))
    })
    
    selection2 <- eventReactive(c(input$go,input$comparison_checkbox),{
      if(input$comparison_checkbox){
        get_precip_deviation_data(selected_points_compare(),
                                  data_choice=paste("Selection 2 - ",input$comparison_state))
      }
    })
    
    precip_deviation_data <- eventReactive(c(input$go,input$comparison_checkbox,input$baseline),{
      if(input$comparison_checkbox){
        data <- rbind(selection1(),selection2())
      }else{
        data <- selection1()
      }
      if(input$baseline){
        data <- rbind(data,us_deviation)
      }
      data
    })
    
    ############################################################
    #####  Render precip deviation plots 
    ############################################################
    output$precip_deviation_plot <- renderPlot({
      # Initialize with overall US value
      if(input$go == 0){
        #return(monthly_precip_deviation(us_deviation) + ggtitle("Select points and click go"))
        return(seasonal_precip_deviation(us_deviation)) # + ggtitle("Select points and click go"))
        }
      # If selection clears show US value
      if(is_empty()){
        #return(monthly_precip_deviation(us_deviation) + ggtitle("Select points and click go"))
        return(seasonal_precip_deviation(us_deviation,empty = TRUE))
        }
      # Plot with selections
      #monthly_precip_deviation(precip_deviation_data())
      if(!is_comparison_empty()){
        return(seasonal_precip_deviation(precip_deviation_data(),compare = TRUE))
      }
      seasonal_precip_deviation(precip_deviation_data())
    })

    output$yearly_precip_deviation <- renderPlot({
      if(input$go == 0 ){return(err_plot)}
      
      precip_deviation_data() %>% 
        ggplot() +
        geom_hline(yintercept = 0,linetype = "dashed") +
        #geom_line(aes(x = as.Date(month_date), y = mean_deviation,
        geom_line(aes(x = as.Date(quarter_date), y = mean_deviation,
                      group = data_choice,
                      color = data_choice)) +
        scale_x_date() +
        scale_y_continuous(n.breaks = 3) +
        theme_dd() +
        theme(panel.background = element_rect(fill = "transparent",colour = NA),
              plot.background = element_rect(fill = "transparent",colour = NA),
              legend.title = element_blank()) +
        labs(x = "", y = expression(dryer %<->% wetter))
    })
    
    
    output$precip_strips <- renderPlot({
      #if(is_empty()){return(err_plot)}
      if(input$go == 0){
        #return(monthly_strips(us_deviation) + ggtitle("Select points and click go"))
        return(seasonal_strips(us_deviation)) #+ ggtitle("Select points and click go"))
      }
      # If selection clears show US value
      if(is_empty()){
        #return(monthly_strips(us_deviation) + ggtitle("Select points and click go"))
        return(seasonal_strips(us_deviation))
      }
      seasonal_strips(precip_deviation_data())
      #monthly_strips(precip_deviation_data())
    })
    

    #### End MLE's stuff
    ####################################################

    
    # JessRoseRobbieJo
    ####################################################
    
    Select1 <- eventReactive(c(input$go, input$Year), {
      points <- selected_points() %>% filter(dataset == "era")
      BigDF %>%
        filter(between(lon,
                       ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon),
                       ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon)),
               between(lat,
                       ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat),
                       ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat))) %>%
        filter(between(Year, as.numeric(input$Year[1]), as.numeric(input$Year[2]))) %>%
        group_by(locat, Year, Month) %>%
        summarise(TotMoPrecipByLocat=sum(PREC)) %>%      # Total precip for month, by station
        group_by(Year, Month) %>%
        summarise(AveTotMoPrecip = mean(TotMoPrecipByLocat)) %>%
        group_by(Year) %>%
        summarise(varTotPrecip = var(AveTotMoPrecip)) %>%
        mutate(Selection = paste("Selection 1 - ", input$state))
    })
    
    Select2 <- eventReactive(c(input$go, input$Year), {
      if(input$comparison_checkbox){
        points <- selected_points_compare() %>% filter(dataset == "era")
        BigDF %>%
          filter(between(lon,
                         ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon),
                         ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon)),
                 between(lat,
                         ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat),
                         ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat))) %>%
          filter(between(Year, as.numeric(input$Year[1]), as.numeric(input$Year[2]))) %>%
          group_by(locat, Year, Month) %>%
          summarise(TotMoPrecipByLocat=sum(PREC)) %>%      # Total precip for month, by station
          group_by(Year, Month) %>%
          summarise(AveTotMoPrecip = mean(TotMoPrecipByLocat)) %>%
          group_by(Year) %>%
          summarise(varTotPrecip = var(AveTotMoPrecip)) %>%
          mutate(Selection = paste("Selection 2 - ", input$comparison_state))
      }
    })
  
     VarPlotData <- eventReactive(c(input$go, input$Year, input$comparison_checkbox), {
       if(input$comparison_checkbox){
         return(rbind(Select1(), Select2()))
       }
       else{
         return(Select1())
       }
     })
     
     Select1T <- eventReactive(c(input$go, input$Year), {
       points <- selected_points() %>% filter(dataset == "era")
       BigDF %>%
         filter(between(lon,
                        ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon),
                        ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon)),
                between(lat,
                        ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat),
                        ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat))) %>%
         filter(between(Year, as.numeric(input$Year[1]), as.numeric(input$Year[2]))) %>%
         group_by(locat, Year) %>%
         summarise(TotPrecipByLocat=sum(PREC)) %>%
         mutate(CumuPrecipByLocat=cumsum(TotPrecipByLocat)) %>%
         group_by(Year) %>%
         summarise(AveTotYrPrecip = mean(TotPrecipByLocat),
                   AveCumuPrecip = mean(CumuPrecipByLocat)) %>%
         mutate(Selection = paste("Selection 1 - ", input$state))
     })
     
      Select2T <- eventReactive(c(input$go, input$Year), {
       if(input$comparison_checkbox){
         points <- selected_points_compare() %>% filter(dataset == "era")
         BigDF %>%
           filter(between(lon,
                          ifelse(identical(points$min_lon,numeric(0)),0,points$min_lon),
                          ifelse(identical(points$max_lon,numeric(0)),0,points$max_lon)),
                  between(lat,
                          ifelse(identical(points$min_lat,numeric(0)),0,points$min_lat),
                          ifelse(identical(points$max_lat,numeric(0)),0,points$max_lat))) %>%
           filter(between(Year, as.numeric(input$Year[1]), as.numeric(input$Year[2]))) %>%
           group_by(locat, Year) %>%
           summarise(TotPrecipByLocat=sum(PREC)) %>%
           mutate(CumuPrecipByLocat=cumsum(TotPrecipByLocat)) %>%
           group_by(Year) %>%
           summarise(AveTotYrPrecip = mean(TotPrecipByLocat),
                     AveCumuPrecip = mean(CumuPrecipByLocat)) %>%
           mutate(Selection = paste("Selection 2 - ", input$comparison_state))
       }
       })
       
    TotPlotData <- eventReactive(c(input$go, input$Year, input$comparison_checkbox), {
      if(input$comparison_checkbox){
        return(rbind(Select1T(), Select2T()))
      }
      else{
        return(Select1T())
      }
    })      
      
    
   xAxisTicks <- eventReactive(c(input$go, input$Year), {
     # If number of years plotted is odd, the last label will occur before the last plotted point, so
     # add two to the final year displayed
     if ((input$Year[2] - input$Year[1]) %% 2 > 0) {
       max_year <- input$Year[2] + 2
     }
     else {
       max_year <- input$Year[2]
      }

      # If over 10 years plotted, only label at every other break
      if ((input$Year[2]-input$Year[1]) > 10) {
        breaks <- seq(from = input$Year[1],
                      to = max_year,
                      by = 2)
      } else {
        breaks <- seq(from = input$Year[1],
                      to = max_year,
                      by = 1)
      }
    })

   output$TotPlot <- renderPlot({
      xAxisTicks()
      TotPlotData()
      ggplot(TotPlotData())+
        geom_line(aes(x=Year, y=AveTotYrPrecip, color=Selection, group=Selection), size=1.5)+
        labs(y="Total yearly precipitation (m)")+
        scale_color_manual(values=c("#440154FF","#1F968BFF"))+
        scale_x_continuous(breaks=xAxisTicks(), labels=xAxisTicks())+
        theme(text = element_text(size=20))+
        theme_dd()
   })
   
    output$VarPlot <- renderPlot({
      xAxisTicks()
      VarPlotData()
      ggplot(VarPlotData())+
        geom_line(aes(x=Year, y=varTotPrecip, color=Selection, group=Selection), size=1.5)+
        labs(y="Variance in Total Monthly Precipitation (m)")+
        scale_color_manual(values=c("#440154FF","#1F968BFF"))+
        scale_x_continuous(breaks=xAxisTicks(), labels=xAxisTicks())+
        theme(text = element_text(size=19))+
        theme_dd()
    })

    output$CumuPlot <- renderPlot({
      TotPlotData()
      xAxisTicks()
      ggplot(TotPlotData())+
        geom_line(aes(x=Year, y=AveCumuPrecip, color=Selection, group=Selection), size=1.5)+
        labs(y="Cumulative precipitation (m)")+
        scale_color_manual(values=c("#440154FF","#1F968BFF"))+
        scale_x_continuous(breaks=xAxisTicks(), labels=xAxisTicks())+
        theme(text = element_text(size=20))+
        theme_dd()
      })
    
    }

