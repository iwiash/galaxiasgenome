## cross validation plot

ggplot(CV, aes(x = K, y = CV)) +
  geom_point() +
  #geom_line() +  
  labs(title = "Cross-Validation Plot", 
       x = "K", 
       y = "Cross-Validation Error") +
  theme_minimal()

## all K values

all_data %>%
  ggplot(.,aes(x=sample, y=value, fill = factor(Q))) + 
  geom_bar(stat ="identity", position = "stack") +
  geom_col(color = NA, width = 1)+
  xlab("Sample") + ylab("Ancestry") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())+
  scale_fill_manual(values = mycol2 , name = "Q", labels=seq(1:14)) +
  facet_wrap(~k,ncol=1) + 
  theme(strip.text = element_blank())

## best 3 k values based on cross validation

all_data %>%
  filter(k == 7) %>%
  ggplot(.,aes(x=sample,y=value,fill=factor(Q))) + 
  geom_bar(stat="identity",position="stack") +
  geom_col(color = NA, width = 1)+
  xlab("Sample") + ylab("Ancestry") +
  theme(axis.text.x = element_text(angle = 60, hjust = 1, size = 4)) +
  scale_fill_manual(values = mycol2, name = "Q", labels=seq(1:14))

all_data %>%
  filter(k == 8) %>%
  ggplot(.,aes(x=sample,y=value,fill=factor(Q))) + 
  geom_bar(stat="identity",position="stack") +
  geom_col(color = NA, width = 1)+
  xlab("Sample") + ylab("Ancestry") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1, size = 4)) +
  scale_fill_manual(values = mycol2, name="Q", labels=seq(1:14))

all_data %>%
  filter(k == 10) %>%
  ggplot(.,aes(x=sample,y=value,fill=factor(Q))) + 
  geom_bar(stat="identity",position="stack") +
  geom_col(color = NA, width = 1)+
  xlab("Sample") + ylab("Ancestry") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1, size = 4)) +
  scale_fill_manual(values = mycol2, name="Q", labels=seq(1:14))



