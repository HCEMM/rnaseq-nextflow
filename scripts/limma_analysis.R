library(limma)
library(edgeR)
library(tximport)
options(echo=F)

# 1. SETUP: Parse Named Arguments
args <- commandArgs(trailingOnly = TRUE)
quant_input <- NULL
tx2gene_input <- NULL
metadata_input <- NULL
for (i in seq_along(args)) {
  if (args[i] == "--quant_dirs") quant_input <- args[i+1]
  if (args[i] == "--tx2gene") tx2gene_input <- args[i+1]
  if (args[i] == "--metadata") metadata_input <- args[i+1]
}

if (is.null(quant_input) || is.null(tx2gene_input) || is.null(metadata_input)) {
  stop("Usage: Rscript limma_analysis.R --quant_dirs <dir1,dir2,...> --tx2gene <tx2gene.csv> --metadata <samples.csv>")
}

# 2. MAP NAMES: Load the pre-made tx2gene CSV
cat("Loading transcript-to-gene mapping...\n")
tx2gene <- read.csv(tx2gene_input, header = TRUE)

# 3. LOAD DATA (tximport for Salmon)
cat("Importing Salmon quantifications...\n")
quant_dirs <- unlist(strsplit(quant_input, ","))
files <- file.path(quant_dirs, "quant.sf")

# Simplify names to just the SRR ID for the plots
#short_names <- gsub(".*(SRR[0-9]+).*", "\\1", quant_dirs)
short_names <- basename(quant_dirs)
short_names <- gsub("_.*", "", short_names)
names(files) <- short_names

print(files) # Debug: Check that files are correctly named and paths are correct
print(short_names) # Debug: Check that short names are correctly extracted


# Import and summarize to gene level
txi <- tximport(files, type = "salmon", tx2gene = tx2gene, ignoreTxVersion = TRUE, ignoreAfterBar = TRUE, dropInfReps = TRUE)

metadata <- read.csv(metadata_input, header = TRUE)
metadata <- metadata[match(short_names, metadata$Accession), ] # Ensure order matches quant_dirs
if (any(is.na(metadata$Accession))) {
  stop("Sample IDs in metadata do not match quantification directories.")
}
print(metadata) # Debug: Check that metadata is correctly loaded
# 4. PREPARE: Voom Normalization & Groups
group <- factor(metadata$Group)
print(levels(group))
print(table(group))
#group <- relevel(group, ref = "Untreated") # Ensure Control is the reference level
design <- model.matrix(~group)

# Create a DGEList from tximport counts, then apply voom
y <- DGEList(txi$counts)
y <- calcNormFactors(y)
v <- voom(y, design, plot=FALSE)

# Extract logCPM for our plots from the voom object
logCPM <- v$E 

# 5. ANALYSIS: The Limma Pipeline
fit <- lmFit(v, design)
fit <- eBayes(fit, trend=TRUE)

# 6. MERGE: Get results
results <- topTable(fit, coef=2, number=Inf)
results$Symbol <- rownames(results) # tximport already mapped these to Gene Symbols!
results <- results[order(results$adj.P.Val), ]
write.csv(results, "final_results.csv", row.names=FALSE)

# --- THE SIMPLIFIED PLOTS ---
cat("Generating plots...\n")
pdf("expression_summary.pdf", width=8, height=8)

# 7. PLOT: PCA 
plotMDS(logCPM, labels = short_names, col=as.numeric(group), pch=19, main="PCA - Sample Clustering")
legend("topleft", legend=levels(group), col=1:2, pch=19)

# 8. PLOT: Volcano 
volcanoplot(fit, coef=2, main="Volcano Plot", highlight=40, names=results$Symbol)
abline(h=-log10(0.05), col="green", lty=2)

# 9. PLOT: Boxplots of Top 40 Genes
par(mfrow=c(2,2))
for (i in 1:40) {
  gene_sym <- results$Symbol[i]
  boxplot(logCPM[gene_sym, ] ~ group, main=gene_sym, 
          col=c("skyblue", "orange"), ylab="Relative Expression (log2 CPM)")
  stripchart(logCPM[gene_sym, ] ~ group, add=TRUE, vertical=TRUE, pch=21, bg="white")
}
par(mfrow=c(1,1)) 

# 10. PLOT: Sample Distance Heatmap
sampleDists <- as.matrix(dist(t(logCPM)))
heatmap(sampleDists, 
        main="Sample Euclidean Distance (Similarity)",
        symm = TRUE,
        col = cm.colors(256),  
        margins = c(10,10))

# 11. PLOT: Top 50 Genes Heatmap
top50_syms <- results$Symbol[1:50]
heatmap_matrix <- logCPM[top50_syms, ]
RdBu <- colorRampPalette(c("blue", "white", "red"))(256)

heatmap(as.matrix(heatmap_matrix), 
        main="Top 50 Differentially Expressed Genes (z-score)",
        Colv = NA,           
        scale = "row",       
        col = RdBu,   
        margins = c(10,5))

legend("bottomleft",
       legend = c("High", "Mean", "Low"),
       fill = c("red", "white", "blue"),
       border = NA,
       bty = "n")

dev.off()
cat("\nDone! Results saved to CSV and expression_summary.pdf generated.\n")