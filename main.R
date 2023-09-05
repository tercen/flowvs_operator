suppressPackageStartupMessages({
  library(tercen)
  library(dplyr, warn.conflicts = FALSE)
  library(flowVS)
})

ctx = tercenCtx()

df <- ctx %>% as.matrix() %>% t
rn <- ctx$rselect() %>% tidyr::unite("label")
colnames(df) <- rn$label
rownames(df) <- 1:nrow(df)

ff <- tim::matrix_to_flowFrame(df)
fs <- flowSet(ff)
pars <- flowVS::estParamFlowVS(fs, channels = rn$label)
fs_trans <- flowVS::transFlowVS(fs, rn$label, pars)

df_out <- exprs(fs_trans[[1]])
colnames(df_out) <- seq_len(ncol(df_out)) - 1L

df_out %>% 
  as_tibble() %>%
  mutate(.ci = seq_len(nrow(.)) - 1L) %>%
  tidyr::pivot_longer(!matches(".ci"), names_to = ".ri") %>%
  mutate(.ri = as.integer(.ri)) %>%
  ctx$addNamespace() %>%
  ctx$save()
