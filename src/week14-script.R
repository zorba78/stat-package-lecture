require(tidyverse)
require(tidymodels)
require(kableExtra)

dat <- read_rds("data/dysmenorrhea.rds")
dat_lab <- Hmisc::label(dat)
remove_attribute <- function(x) {attributes(x) <- NULL; x}

## two sample t-test: making table
dat %>% 
  mutate_at(vars(age:pdi), 
            ~ remove_attribute(.)) %>% 
  pivot_longer(
    cols = age:pdi,
    names_to = "variable", 
    values_to = "value"
  ) %>% 
  group_by(variable) %>% 
  nest %>% 
  ungroup %>% 
  mutate(ttest_result = map(data, ~ t.test(value ~ pidyn, data = .x, var.equal = TRUE)), 
         name = dat_lab[3:12]) %>% 
  mutate(ttest_result = map(ttest_result, ~tidy(.x))) %>% 
  select(variable, name, ttest_result) %>% 
  unnest(cols = ttest_result) -> ttest_summary

dat %>% 
  mutate_at(vars(age:pdi), 
            ~ remove_attribute(.)) %>% 
  pivot_longer(
    cols = age:pdi,
    names_to = "variable", 
    values_to = "value"
  ) %>% 
  group_by(variable, pidyn) %>% 
  summarise(Mean = mean(value), 
            SD = sd(value)) %>% 
  mutate(res = sprintf("%.1f ± %.1f", Mean, SD)) %>% 
  select(-Mean, -SD) %>% 
  pivot_wider(names_from = pidyn, 
              values_from = res) -> desc_summary


desc_summary %>% 
  inner_join(ttest_summary %>% 
               select(variable:name, statistic, parameter, p.value), 
             by = "variable") %>% 
  mutate(stat = sprintf("$t_{df=%d}$ = %.2f", parameter, statistic)) %>% 
  select(name, Control:Dysmenorrhea, stat, p.value) %>% 
  mutate_if(is.numeric, format, digits = 4) %>% 
  kbl(escape = FALSE) %>% 
  kable_paper()


## Oneway ANOVA ####
require(emmeans)
abalone <- read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", 
                    header = FALSE) 
vname <- c("sex", "length [mm]", "diameter [mm]", "height [mm]", 
           "whole weight [g]", "shucked weight [g]", "viscera weight [g]", "Ring")
abalone %>% 
  mutate(V1 = factor(V1, levels = c("M", "F", "I"))) %>% 
  pivot_longer(cols = V2:V9, 
               names_to = "variable", 
               values_to = "value") -> abalone_long

abalone_long %>% 
  group_by(variable, V1) %>% 
  summarise(Mean = mean(value), 
            SD = sd(value)) %>% 
  mutate(res = sprintf("%.3f ± %.3f", Mean, SD)) %>% 
  select(-Mean, -SD) %>% 
  pivot_wider(names_from = V1, values_from = res) %>% 
  ungroup -> desc_summ

abalone_long %>% 
  group_by(variable) %>% 
  nest %>% 
  ungroup %>% 
  mutate(lm_res = map(data, ~ lm(value ~ V1, data = .x)), 
         aov_res = map(lm_res, ~ glance(.x))) -> lm_summ

lm_summ %>% 
  select(variable, aov_res) %>% 
  unnest(cols = aov_res) %>% 
  select(variable, statistic, p.value) -> aov_summ

desc_summ %>% 
  inner_join(aov_summ, by = "variable") %>% 
  mutate(statistic = format(statistic, digits = 1), 
         p.value = format(p.value, digits = 4)) %>% 
  kbl %>% 
  kable_paper






# dat_nest %>% 
#   mutate(emmeans = pmap(
#     .l = list(object = model, 
#               specs = "SC3"), 
#     .f = emmeans
#   )) %>% 
#   mutate(emcontrast = pmap(
#     .l = list(object = emmeans, 
#               method = "pairwise", 
#               adjust = "bonferroni"), 
#     .f = contrast
#   )) -> tmp
# 
# emm <- tmp %>% 
#   mutate(emres = map(emmeans, 
#                      ~ tidy(.x, conf.int = TRUE))) %>% 
#   select(name, emres) %>% 
#   unnest(cols = emres) %>% 
#   mutate(emm_txt = sprintf("%.2f<br/>(%.2f, %.2f)", estimate, asymp.LCL, asymp.UCL)) %>% 
#   select(name, SC3, emm_txt) %>% 
#   mutate(SC3 = factor(SC3, levels = c("TE", "SE", "SY"))) %>% 
#   pivot_wider(
#     names_from = SC3, 
#     values_from = emm_txt
#   )
# 
# tmp %>% 
#   mutate(emcont = map(emcontrast, 
#                       ~tidy(.x, conf.int = TRUE))) %>% 
#   select(name, emcont) %>% 
#   unnest(cols = emcont) %>% 
#   mutate(cnt_txt = sprintf("%.2f<br/>(%.2f, %.2f)", estimate, asymp.LCL, asymp.UCL)) %>% 
#   select(name, contrast, cnt_txt) %>% 
#   pivot_wider(
#     names_from = contrast, 
#     values_from = cnt_txt
#   ) -> cnt
# 
# res <- emm %>% inner_join(cnt)
# 
# res %>% 
#   kbl(escape = FALSE) %>% 
#   kable_paper("striped", full_width = TRUE) %>% 
#   add_header_above(c(" ", "Estimated marginal mean\n(95 % CI)" = 3, 
#                      "Mean difference between group\n(95 % CI)" = 3))
# 
# 
# 
# d1 <- dat_nest$data[[1]]
# m <- input_model(d1)
# em <- emmeans(m, ~ SC3)
# emct <- contrast(em, method = "pairwise", adjust = "bonferroni")
