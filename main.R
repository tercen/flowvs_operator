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

apply(exprs(fs_trans[[1]]), 2, hist)

(fs_trans$`<B515-A> B515-A`)

  select(.y, .ci, .ri) %>% 
  group_by(.ci, .ri) %>%
  summarise(mean = mean(.y)) %>%
  ctx$addNamespace() %>%
  ctx$save()
