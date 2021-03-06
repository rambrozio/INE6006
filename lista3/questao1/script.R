#LIbraries
library(tables)
library(xtable)

#Options
options(digits = 4, width = 100) #set precision for float values and and chars by line
par(xpd=TRUE,cex.lab=1.5) #set global options for plot

# Run non-LaTex stuff
source("calc.R")

# --- b
powers <- matrix(data=bpower$power, ncol = length(bpower$power), nrow = 1)
colnames(powers) <- us1b
rownames(powers) <- "$1-\\beta$"
table <- xtable(powers, digits=4, label = "tb:1b", 
                caption = "Poder do teste para diferentes valores da média populacional real.")
print.xtable(table, caption.placement = "top", sanitize.text.function = identity, 
             booktabs = TRUE, comment = TRUE, file = "tb-power.tex")

# --- d
powers <- matrix(data=c(dpower$power, bpower$power), ncol = length(dpower$power), nrow = 2, byrow = TRUE)
colnames(powers) <- us1b
rownames(powers) <- c("$1-\\beta_d$", "$1-\\beta_b$")
table <- xtable(powers, digits=4, label = "tb:1d", 
                caption = "Poder do teste usando $s$ e $n$ das amostras dos itens d e b.")
print.xtable(table, caption.placement = "top", sanitize.text.function = identity, 
             booktabs = TRUE, comment = TRUE, file = "tb-power-d.tex")

# --- plot 
deltas <- c(seq(10, 0, by=-0.5), seq(0, 10, by=0.5))
us <- c(seq(-10, 0, by=0.5)+u01a, seq(0, 10, by=0.5)+u01a)
bpowers <- power.t.test(n=n1a, delta=deltas, sd=s1a, sig.level=alpha1a,
                        type="one.sample", alternative="one.sided")$power
dpowers <- power.t.test(n=n1d, delta=deltas, sd=s1d, sig.level=alpha1a,
                        type="one.sample", alternative="one.sided")$power
powers <- matrix(c(us, bpowers, dpowers), nrow = length(deltas), ncol = 3)
colnames(powers) <- c("u", "beta.b", "beta.d")
write.csv(powers, file = "powers.csv", row.names = FALSE, 
          na="", fileEncoding = "UTF-8", eol="\r\n")


# --- vars file
out <- file("vars.tex", open = "w")
cat(sprintf("\\def\\UMAalpha{\\num[round-mode=off]{%.2f}\\xspace}\n", alpha1a), file = out)

cat(sprintf("\\def\\UMAu0{\\num{%d}\\xspace}\n", u01a), file = out)
cat(sprintf("\\def\\UMAn{\\num{%d}\\xspace}\n", n1a), file = out)
cat(sprintf("\\def\\UMAgl{\\num{%d}\\xspace}\n", gl1a), file = out)

cat(sprintf("\\def\\UMAbarx{\\num{%.4f}\\xspace}\n", barx1a), file = out)
cat(sprintf("\\def\\UMAs{\\num{%.4f}\\xspace}\n", s1a), file = out)
cat(sprintf("\\def\\UMAt{\\num{%.4f}\\xspace}\n", t1a), file = out)
cat(sprintf("\\def\\UMAp{\\num{%.4f}\\xspace}\n", p1a), file = out)

cat(sprintf("\\def\\UMCn{\\num{%.4f}\\xspace}\n", n1c), file = out)
cat(sprintf("\\def\\UMCnMin{\\num{%.4f}\\xspace}\n", nMin1c), file = out)
cat(sprintf("\\def\\UMCbeta{\\num{%.4f}\\xspace}\n", beta1c), file = out)
cat(sprintf("\\def\\UMCbetaOld{\\num{%.4f}\\xspace}\n", betaOld1c), file = out)

cat(sprintf("\\def\\UMDs{\\num{%.4f}\\xspace}\n", s1d), file = out)

close(out)

