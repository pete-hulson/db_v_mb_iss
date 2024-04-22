
# load ----
library(tidyverse)
library(tidytable)
library(vroom)
library(here)
library(purrr)
library(rsample)
library(data.table)
library(scico)
library(extrafont)
library(cowplot)
library(egg)
library(gg.layers)
# remotes::install_version("Rttf2pt1", version = "1.3.8")
# extrafont::font_import()
loadfonts(device="win")   

# if you get a lot of messages like 'C:\Windows\Fonts\ALGER.TTF : No FontName. Skipping.'
# then load this package and then run font_import
# remotes::install_version("Rttf2pt1", version = "1.3.8")

# add fonts to all text (last line)
ggplot2::theme_set(
  ggplot2::theme_light() +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      # axis.ticks.length = grid::unit(base_ / 2.2, "pt"),
      strip.background = ggplot2::element_rect(fill = NA, colour = NA),
      strip.text.x = element_text(colour = "black"),
      strip.text.y = element_text(colour = "black"),
      panel.border = element_rect(fill = NA),
      legend.key.size = grid::unit(0.9, "lines"),
      legend.key = ggplot2::element_rect(colour = NA, fill = NA),
      legend.background = ggplot2::element_rect(colour = NA, fill = NA),
      text = element_text(family = "Times New Roman")
    )
)

# get vast estimates of iss ----

cod <- readRDS(here::here('output', 'cod', 'pacific_cod_results.RDS'))

yf <- readRDS(here::here('output', 'yellowfin', 'proportionsVAST_proportions.RDS'))

poll <- readRDS(here::here('output', 'pollock', 'VASTresults_age.RDS'))

cod$Proportions$Neff_tl

yf$Neff_tl

poll$Proportions$Neff_tl

# plot data ----

# annual iss
iss_ann <- vroom::vroom(here::here('output', 'afsc_iss_exp2_ann.csv')) %>% 
  tidytable::mutate(surv_labs = case_when(region == 'goa' ~ "Gulf of Alaska",
                                          region == 'ai' ~ "Aleutian Islands",
                                          region == 'bs' ~ "Eastern Bering Sea Shelf"),
                    err_src = case_when(err_src == 'all' ~ "All",
                                        err_src == 'hl' ~ "Haul",
                                        err_src == 'ln' ~ "Length",
                                        err_src == 'hl_ln' ~ "Haul + Length",
                                        err_src == 'sp' ~ "Specimen"),
                    err_src = factor(err_src, level = c('Haul', 'Length', 'Specimen', 'Haul + Length', 'All'))) 

# mean iss
iss_mu <- vroom::vroom(here::here('output', 'afsc_iss_exp2_mu.csv')) %>% 
  tidytable::mutate(surv_labs = case_when(region == 'goa' ~ "Gulf of Alaska",
                                          region == 'ai' ~ "Aleutian Islands",
                                          region == 'bs' ~ "Eastern Bering Sea Shelf"),
                    err_src = case_when(err_src == 'all' ~ "All",
                                        err_src == 'hl' ~ "Haul",
                                        err_src == 'ln' ~ "Length",
                                        err_src == 'hl_ln' ~ "Haul + Length",
                                        err_src == 'sp' ~ "Specimen"),
                    err_src = factor(err_src, level = c('Haul', 'Length', 'Specimen', 'Haul + Length', 'All'))) 

# plot annual age iss for type & region ----

# with all error sources
iss_ann %>% 
  tidytable::filter(comp_type == 'age',
                    type != 'other') %>% 
  ggplot(., aes(x = err_src, 
                y = iss, 
                fill = sex_cat)) +
  geom_boxplot2(width.errorbar = 0) +
  facet_grid(surv_labs ~ type,
             labeller = label_wrap_gen(10),
             scales = 'free') +
  theme(legend.position = "bottom",
        text = element_text(size = 14),
        strip.text.y.right = element_text(angle = 0),
        axis.text.x = element_text(angle = -45, hjust = 0)) +
  xlab("\nError source") +
  ylab("Age composition input sample size\n") +
  scale_fill_scico_d(palette = 'roma',
                     name = "Composition type") -> iss_age

ggsave(here::here("figs", "iss_age.png"),
       iss_age,
       device = "png",
       width = 7,
       height = 7)

# remove length only case
iss_ann %>% 
  tidytable::filter(comp_type == 'age',
                    type != 'other',
                    err_src != 'Length') %>% 
  ggplot(., aes(x = err_src, 
                y = iss, 
                fill = sex_cat)) +
  geom_boxplot2(width.errorbar = 0) +
  facet_grid(surv_labs ~ type,
             labeller = label_wrap_gen(10),
             scales = 'free') +
  theme(legend.position = "bottom",
        text = element_text(size = 14),
        strip.text.y.right = element_text(angle = 0),
        axis.text.x = element_text(angle = -45, hjust = 0)) +
  xlab("\nError source") +
  ylab("Age composition input sample size\n") +
  scale_fill_scico_d(palette = 'roma',
                     name = "Composition type") -> iss_age_nolen

ggsave(here::here("figs", "iss_age_nolen.png"),
       iss_age_nolen,
       device = "png",
       width = 7,
       height = 7)

# set ylim to 1000
iss_ann %>% 
  tidytable::filter(comp_type == 'age',
                    type != 'other',
                    err_src != 'Length') %>% 
  ggplot(., aes(x = err_src, 
                y = iss, 
                fill = sex_cat)) +
  geom_boxplot2(width.errorbar = 0) +
  facet_grid(surv_labs ~ type,
             labeller = label_wrap_gen(10),
             scales = 'free') +
  theme(legend.position = "bottom",
        text = element_text(size = 14),
        strip.text.y.right = element_text(angle = 0),
        axis.text.x = element_text(angle = -45, hjust = 0)) +
  xlab("\nError source") +
  ylab("Age composition input sample size\n") +
  scale_fill_scico_d(palette = 'roma',
                     name = "Composition type") +
  ylim(0, 1000) -> iss_age_lim

ggsave(here::here("figs", "iss_age_lim.png"),
       iss_age_lim,
       device = "png",
       width = 7,
       height = 7)

# plot annual length iss for type & region ----

iss_ann %>% 
  tidytable::filter(comp_type == 'length',
                    type != 'other') %>% 
  ggplot(., aes(x = err_src, 
                y = iss, 
                fill = sex_cat)) +
  geom_boxplot2(width.errorbar = 0) +
  facet_grid(surv_labs ~ type,
             labeller = label_wrap_gen(10),
             scales = 'free') +
  theme(legend.position = "bottom",
        text = element_text(size = 14),
        strip.text.y.right = element_text(angle = 0),
        axis.text.x = element_text(angle = -45, hjust = 0)) +
  xlab("\nError source") +
  ylab("Length composition input sample size\n") +
  scale_fill_scico_d(palette = 'roma',
                     name = "Composition type") -> iss_len

ggsave(here::here("figs", "iss_len.png"),
       iss_len,
       device = "png",
       width = 7,
       height = 7)

# set ylim to 5,000
iss_ann %>% 
  tidytable::filter(comp_type == 'length',
                    type != 'other') %>% 
  ggplot(., aes(x = err_src, 
                y = iss, 
                fill = sex_cat)) +
  geom_boxplot2(width.errorbar = 0) +
  facet_grid(surv_labs ~ type,
             labeller = label_wrap_gen(10),
             scales = 'free') +
  theme(legend.position = "bottom",
        text = element_text(size = 14),
        strip.text.y.right = element_text(angle = 0),
        axis.text.x = element_text(angle = -45, hjust = 0)) +
  xlab("\nError source") +
  ylab("Length composition input sample size\n") +
  scale_fill_scico_d(palette = 'roma',
                     name = "Composition type") +
  ylim(0, 5000) -> iss_len_lim

ggsave(here::here("figs", "iss_len_lim.png"),
       iss_len_lim,
       device = "png",
       width = 7,
       height = 7)



