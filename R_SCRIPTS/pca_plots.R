## SCREE PLOT

ggplot(eigenval, aes(x = PC, y = V1)) +
  geom_point(size = 3) +
  geom_line() +
  scale_x_continuous(n.breaks = 10) +
  xlab("Principal Component") +
  ylab("Eigenvalue") +
  ggtitle("Scree Plot") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20)) +
  theme(panel.grid.minor.x = element_blank()) 

## ALL POPS - PC1/2

##plotly::ggplotly(
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
##)

## PC2/3
ggplot(fulldata, aes(x = PC2, y = PC3, color = POP)) +
  geom_point(aes(color = POP, shape = MIGRATORYSTATUS), size = 3.5, alpha = 0.8 ) +
  scale_color_manual(values = colours) +
  scale_shape_manual(values = c("Diadromous" = 15, "Non-Diadromous" = 19)) +
  labs( title = "Principal Component Analysis - PC2/PC3", 
         color = "Population",shape = "Migratory Status") +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC2: ", round(percent_var[2], 2), "% variance")) +
  ylab(paste0("PC3: ", round(percent_var[3], 2), "% variance")) +
  ##geom_text_repel(aes(label = POP), size = 3) +
  theme_minimal()

## PC3/4
ggplot(fulldata, aes(x = PC3, y = PC4, color = POP)) +
  geom_point(aes(color = POP, shape = MIGRATORYSTATUS), size = 3.5, alpha = 0.8 ) +
  scale_color_manual(values = colours) +
  scale_shape_manual(values = c("Diadromous" = 15, "Non-Diadromous" = 19)) +
  labs( title = "Principal Component Analysis - PC3/PC4", 
         color = "Population",shape = "Migratory Status") +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC3: ", round(percent_var[3], 2), "% variance")) +
  ylab(paste0("PC4: ", round(percent_var[4], 2), "% variance")) +
  ##geom_text_repel(aes(label = POP), size = 3) +
  theme_minimal()

## only diadromous

ggplot(migfulldata, aes(x = PC1, y = PC2, color = POP)) +
  geom_point(size = 4, alpha = 0.8) +
  labs( title = "Principal Component Analysis - Mainland Migratory Locations", 
        subtitle = "PC1/PC2", color = "Population") +
  #geom_point(data=subset(heterodata, IID == "KOARO_163.1"), color = "red") +
  scale_color_manual(values = colours) +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC1: ", round(migpercent_var[1], 2), "% variance")) +
  ylab(paste0("PC2: ", round(migpercent_var[2], 2), "% variance")) +
  ##geom_text_repel(aes(label = POP), size = 3) +
  theme_minimal()

########################## bad stuff
ggplot(fulldata, aes(x = PC1, y = PC2, color = POP)) +
  geom_point(size = 3.5, alpha = 0.8) +
  scale_color_manual(values = colours) +

  labs( title = "Principle Component Analysis - All Populations", 
        subtitle = "PC1/PC2", color = "Population") +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC1: ", round(percent_var[1], 2), "% variance")) +
  ylab(paste0("PC2: ", round(percent_var[2], 2), "% variance")) +
  theme_minimal()

## NO CHATH

ggplot(nochath, aes(x = PC1, y = PC2, color = POP)) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_manual(values = colours) +
  geom_point(data=subset(nochath, IID == "KOARO_163.1"), color = "red") +
  labs( title = "Principle Component Analysis - No Chatham Is.", 
        subtitle = "PC1/PC2", color = "Population") +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC1: ", round(nochath_percent_var[1], 2), "% variance")) +
  ylab(paste0("PC2: ", round(nochath_percent_var[2], 2), "% variance")) +
  ##geom_text_repel(aes(label = POP), size = 3) +
  theme_minimal()

## NO ISLANDS PC1/2

ggplot(noislands, aes(x = PC1, y = PC2, color = POP)) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_manual(values = colours) +
  labs( title = "Principle Component Analysis - Mainland only", 
        subtitle = "PC1/PC2", color = "Population") +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC1: ", round(noisland_percent_var[1], 2), "% variance")) +
  ylab(paste0("PC2: ", round(noisland_percent_var[2], 2), "% variance")) +
  ##geom_text_repel(aes(label = POP), size = 3) +
  theme_minimal()

ggplot(lst, aes(x = PC1, y = PC2, color = DIADROMOUS)) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_manual(values = colours) +
  labs( title = "Principle Component Analysis - Mainland only", 
        subtitle = "PC1/PC2", color = "Population") +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC1: ", round(lst_percent_var[1], 2), "% variance")) +
  ylab(paste0("PC2: ", round(lst_percent_var[2], 2), "% variance")) +
  ##geom_text_repel(aes(label = POP), size = 3) +
  theme_minimal()

## NO LST PC1/2


ggplot(lst, aes(x = PC1, y = PC2, color = POP)) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_manual(values = colours) +
  labs( title = "Principle Component Analysis - Mainland - No LST", 
        subtitle = "PC1/PC2", color = "Population") +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC1: ", round(lst_percent_var[1], 2), "% variance")) +
  ylab(paste0("PC2: ", round(lst_percent_var[2], 2), "% variance")) +
  ##geom_text_repel(aes(label = POP), size = 3) +
  theme_minimal()


ggplot(migfulldata, aes(x = PC1, y = PC2, color = POP)) +
  geom_point(size = 4, alpha = 0.8) +
  labs( title = "Principle Component Analysis - Mainland Migratory Locations", 
        subtitle = "PC1/PC2", color = "Population") +
  #geom_point(data=subset(heterodata, IID == "KOARO_163.1"), color = "red") +
  scale_color_manual(values = colours) +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC1: ", round(migpercent_var[1], 2), "% variance")) +
  ylab(paste0("PC2: ", round(migpercent_var[2], 2), "% variance")) +
  ##geom_text_repel(aes(label = POP), size = 3) +
  theme_minimal()

ggplot(heterodata, aes(x = PC1, y = PC2, color = OHOM)) +
  geom_point(size = 4,) +
  scale_color_continuous(low = "#633372FF", high = "#92C051FF",) +
  labs( title = "Principle Component Analysis - Mainland Migratory Locations", 
        subtitle = "PC1/PC2", color = "Homozygosity") +
  ##stat_ellipse(type="norm") +
  xlab(paste0("PC1: ", round(migpercent_var[1], 2), "% variance")) +
  ylab(paste0("PC2: ", round(migpercent_var[2], 2), "% variance")) +
  ##geom_text_repel(aes(label = POP), size = 3) +
  theme_minimal() 
