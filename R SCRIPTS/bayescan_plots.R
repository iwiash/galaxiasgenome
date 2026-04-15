manhattan_fst

scaff17

string_scaff17

stringent_manhattan


graph_1 = ggplot(bayescan, aes(x = LOG10_Q, y = FST)) 

colours = c("Non-significant" = "black", "Significant" = "red")
x_title="-Log10(q-value)" 
y_title=(expression(F[ST]))

bayescan$zeroQ = ifelse(bayescan$Q_VALUE < 0.000001, "Highly-Significant", "Non-significant")
bayescan$zeroQ = factor(bayescan$zeroQ)
bayescan %>% group_by(zeroQ) %>% tally()

plotdf = as.data.frame(bayescan)

ggplot(bayescan, aes(x = LOG10_Q, y = FST)) +
  geom_point(aes(fill = ifelse(SELECTION == "Diversifying", "Significant", "Background")), pch=21, size=3, alpha = 0.7) + 
  #geom_point(data = subset(plotdf , zeroQ == "Highly-Significant"), colour = "red", size = 3, alpha = 0.8 )+
  #geom_text()+ 
  scale_fill_manual(name = "Selection", values = c("Significant" = "red", "Background" = "white")) +
  labs( title = "BayeScan Results", 
        color = "Population") +
  labs(x=x_title)+ 
  labs(y=y_title)+ 
  #theme(axis.title=element_text(size=12, family="Helvetica",face="bold"), legend.position="none")+
  #theme(axis.text.x=element_text(colour="black"))+ 
  #theme(axis.text.y=element_text(colour="black",size=12))+ 
  #theme(axis.text.x=element_text(colour="black",size=12))+ 
  #theme(panel.border = element_rect(colour="black", fill=NA, size=3),  
  #      axis.title=element_text(size=18,colour="black",family="Helvetica",face="bold")) +
  theme_minimal() +
  #geom_vline(xintercept = log_cutoff, linetype="dashed", color="red", linewidth=1) +
  geom_vline(xintercept = log_cutoff_0.01, linetype="dashed", color="blue", linewidth=1) 


ggplot(bayescan, aes(x = LOG10_Q, y = FST, color = SIG)) +
  geom_point(aes(color = SIG), shape = 19, size=3, alpha = 0.8) + 
  scale_color_manual(name = "Selection", values = c("Significant" = "red", "Background" = "black")) +
  labs(x=x_title)+ 
  labs(y=y_title)+ 
  theme(axis.title=element_text(size=20, family="Helvetica",face="bold"), legend.position="none")+
  theme(axis.text.x=element_text(colour="black", size=20))+ 
  theme(axis.text.y=element_text(colour="black",size=12))+ 
  theme(axis.text.x=element_text(colour="black",size=12))+ 
  theme(panel.border = element_rect(colour="black", fill=NA, size=3),  
        axis.title=element_text(size=18,colour="black",family="Helvetica",face="bold")) +
  theme_classic() +
  geom_vline(xintercept = log_cutoff, linetype="dashed", color="red", linewidth=1) +
  geom_vline(xintercept = log_cutoff_0.01, linetype="dashed", color="blue", linewidth=1) 

plot1 = ggplot(df, aes(x = LOG10_Q, y = FST, colour = SIG)) 

plot1 +
  
  ggplot(df, aes(x = LOG10_Q, y = FST, colour = SIG)) +
  geom_point(shape = 19, size=3, alpha = 0.8) +
  scale_color_manual(values = c("Significant" = "red", "Non-significant" = "transparent")) + 
  #scale_fill_manual(values = c("Significant" = "red", "Non-significant" = "black")) +
  xlab("-Log10(q-value)") +
  ylab(expression(F[ST])) +
  labs( title = "PLOT TITLE" ,
        fill = "Signficance")
  
  
ggplot(fulldata, aes(x = PC1, y = PC2, color = POP)) +
  geom_point(aes(color = POP, shape = MIGRATORYSTATUS), size = 3.5, alpha = 0.8 ) +
  scale_color_manual(values = colours) +
  scale_shape_manual(values = c("Diadromous" = 15, "Non-Diadromous" = 19)) +
  labs( title = "Principal Component Analysis - PC1/PC2", 
        color = "Population",shape = "Migratory Status") +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC1: ", round(percent_var[1], 2), "% variance")) +
  ylab(paste0("PC2: ", round(percent_var[2], 2), "% variance")) +
  ##geom_text_repel(aes(label = POP), size = 3) +
  theme_minimal()


manhattan_fst = ggplot(df, 
                       aes(x = CUMULATIVEBP, y = FST, color = as_factor(CHROM))) + 
  geom_point(size = 3 , alpha = 0.5, ) +
  scale_x_continuous( label = axis_set$CHROM, breaks = axis_set$center,) +
  scale_color_manual(values = rep(c("darkgrey", "#363636"), unique(length(axis_set$CHROM)) )) +
  geom_point(data=subset(df, SIG=="Signficant"), color="red", size=3, alpha = 0.5) +
  labs( #title = "Manhattan Plot - BayeScan Outlier Analysis", 
        #subtitle = "GBS SNP data mapped to Galaxias brevipinnis reference genome" , 
        x = NULL, y = NULL , ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 20), 
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.text.x = element_blank(),
    )

manhattan_fst
