#' COOBoostR() function
#'
#' This function finds Cell Of Origin by xgboost
#'
#' @param sourcePath sourcePath, must end with a dir delimiter(ex : /)
#' @param resultPath resultPath, must end with a dir delimiter(ex : /)
#' @param epimarker_rawdata epimarker data
#' @param mutation_rawdata mutation data
#' @param mEta Learning Rate (default 0.03)
#' @param mdepth max depth (default 2)
#' COOBoost_main(path, top, mutation, initJar, rp, nround)
#' @export

COOBoostR <- function(sourcePath, resultPath, epimarker_rawdata, mutation_rawdata, mEta = 0.03, mdepth = 2){

  #define serveral paths
  #------------------------------------------------------------------
  sourcePath <- sourcePath
  resultPath  <- resultPath
  #------------------------------------------------------------------

  #read epimarker_rawdata & mutation_rawdata
  #------------------------------------------------------------------
  epimarker_rawdata <- paste0(sourcePath, epimarker_rawdata)
  bio = read.csv(epimarker_rawdata)
  mutation_rawdata <- paste0(sourcePath, mutation_rawdata)
  mutation = read.csv(mutation_rawdata)
  #------------------------------------------------------------------

  #set repeat count.
  #------------------------------------------------------------------
  nround = 20
  #------------------------------------------------------------------
  rp = 10
  mEta = mEta #default : 0.01
  obj = "multi:softmax"
  eval_met = "merror"
  msubsample = 0.9
  mgamma = 0 # default : 0
  mdepth = mdepth #max_depth_default : 2
  featureCnt = 20

  mutationPath <- strsplit(mutation_rawdata,'/')
  name <- mutationPath[[1]][length(mutationPath[[1]])]
  folderName <- substr(name,0,which(strsplit(name, "")[[1]]==".")-1)

  check_dir(resultPath,folderName)
  resultPath <- paste0(resultPath,folderName,'/')

  #rotation all mutations
  #------------------------------------------------------------------
  for(mutaionIndex in 1: ncol(mutation))
  {
    mutationload <- mean(data.matrix(mutation[mutaionIndex]))
    print(paste(colnames(mutation[mutaionIndex]),'_mutationload: ',mutationload))
    if((2 * mutationload) > as.numeric(nrow(mutation[mutaionIndex])) || (mutationload < 0.002)) next

    if(ncol(bio) < 20)  {
      featureCnt <- ncol(bio)
    }

    progSt <- proc.time()
    #repeat 100 to calculate average of epimarker's rank
    #------------------------------------------------------------------
    for(repeatCount in 1:rp)
    {
      #split training & test data (9:1)
      #------------------------------------------------------------------
      repeat{
        ind <- sample(2, nrow(bio), replace = TRUE, prob = c(0.9, 0.1))
        train = bio[ind==1,]
        test = bio[ind==2,]
        if(length(which(ind == 2))  > 0) break

      }
      #------------------------------------------------------------------

      #check the name of mutation on the console.
      # print(colnames(mutation[mutaionIndex]))

      #set label data
      #------------------------------------------------------------------
      train_y = mutation[ind==1,c(mutaionIndex)]
      mutationName <- colnames(mutation[c(mutaionIndex)])

      test_y = mutation[ind==2,c(mutaionIndex)]
      #------------------------------------------------------------------

      num_class <- as.integer(max(mutation[mutaionIndex])) +1

      #set general parameters
      #------------------------------------------------------------------
      params <- list(booster = "gbtree",objective = obj, num_class=num_class, eval_metric = eval_met, num_feature=ncol(bio))
      #------------------------------------------------------------------

      #make adequate data format to use in XGBoost library..
      #------------------------------------------------------------------
      dtrain = xgb.DMatrix(as.matrix(train),label=train_y)
      dtest= xgb.DMatrix(as.matrix(test),label=test_y)
      #------------------------------------------------------------------

      watchlist=list(train=dtrain,test=dtest)

      #check excution time
      ptm <- proc.time()

      bst = xgb.train(data = dtrain,watchlist = watchlist, params = params, nrounds = nround,verbose = 0, eta = mEta, gamma = mgamma, max_depth = mdepth)
      # print(repeatCount);print(proc.time() - ptm)


      #get importance from model.
      #------------------------------------------------------------------
      importance <- xgb.importance(feature_names = colnames(train),model=bst)
      #------------------------------------------------------------------
      # print(resultPath)
      #save epimarker's importance TOP20
      #------------------------------------------------------------------
      capture.output(print(bst$evaluation_log),file= paste0(resultPath,'evalLog_',mutationName,'.txt'),append=TRUE)
      #------------------------------------------------------------------


      #saving the ordered epimarkers(rank)
      #------------------------------------------------------------------
      for(i in 1: nrow(importance)) {
        capture.output(cat(' ',importance$Feature[i]),file= paste0(resultPath,'rank_',mutationName,'.txt'),append=TRUE)
        # capture.output(cat(' ',importance$Gain[i]),file= paste0(resultPath,'gain_',mutationName,'.txt'),append=TRUE)
      }
      #------------------------------------------------------------------
      #new line
      capture.output(cat('\n'),file= paste0(resultPath,'rank_',mutationName,'.txt'),append=TRUE)
      # capture.output(cat('\n'),file= paste0(resultPath,'gain_',mutationName,'.txt'),append=TRUE)
    }
    #------------------------------------------------------------------

    #excute writeFile / in COOBoost excute external .jar file.
    #------------------------------------------------------------------

    rankdf <- readFile(path = resultPath, top = 20, mutation = colnames(mutation[mutaionIndex]), initJar = "t", bio_colnames = colnames(bio))
    writeFile(path = resultPath, top = 20, mutation = colnames(mutation[mutaionIndex]), initJar = "t", rp = rp, nround = nround, rankdf = rankdf)

    #------------------------------------------------------------------

    capture.output(cat(proc.time() - progSt),file= paste0(resultPath,'time_',mutationName,rp,'rp.txt'),append=TRUE)


    #------------------------------------------------------------------------------------------#
    #----------------------------------------- top 1 ------------------------------------------#
    for(topCount in featureCnt:1)
    {
      #peeking top rank of epimarker and data
      #------------------------------------------------------------------
      before_resultdata <- paste0(resultPath,'output_',colnames(mutation[mutaionIndex]),'.txt')
      before_result <-read.csv(before_resultdata)

      if (exists("top20")){
        rm(top20)
      }
      if (exists("top20_sub")){
        rm(top20_sub)
      }

      for(i in 1:topCount){
        name <- as.character(before_result[i,1])
        #print(name)
        top20_sub <- as.data.frame(as.numeric(bio[,name]))
        names(top20_sub)<-name
        if(i == 1)  {
          top20 <- cbind(top20_sub)
        }
        else  {
          top20 <- cbind(top20,top20_sub)
        }
      }
      # print(colnames(top20))
      # print(dim(top20))
      #------------------------------------------------------------------

      #repeat 100 to calculate average of epimarker's rank
      #------------------------------------------------------------------
      for(repeatCount in 1:rp)
      {
        #split training & test data (9:1)
        #------------------------------------------------------------------
        repeat{
          ind <- sample(2, nrow(top20), replace = TRUE, prob = c(0.9, 0.1))
          train = top20[ind==1,]
          test = top20[ind==2,]
          if(length(which(ind == 2))  > 0) break
        }
        #------------------------------------------------------------------

        #check the name of mutation on the console.
        # print(colnames(mutation[mutaionIndex]))

        #set label data
        #------------------------------------------------------------------
        train_y = mutation[ind==1,c(mutaionIndex)]
        mutationName <- colnames(mutation[c(mutaionIndex)])

        test_y = mutation[ind==2,c(mutaionIndex)]
        #------------------------------------------------------------------

        num_class <- as.integer(max(mutation[mutaionIndex]))+1

        #set general parameters
        #------------------------------------------------------------------
        params <- list(booster = "gbtree",objective = obj, num_class=num_class, eval_metric = eval_met, num_feature=topCount)
        #------------------------------------------------------------------

        #make adequate data format to use in XGBoost library..
        #------------------------------------------------------------------
        dtrain = xgb.DMatrix(as.matrix(train),label=train_y)
        dtest= xgb.DMatrix(as.matrix(test),label=test_y)
        #------------------------------------------------------------------

        watchlist=list(train=dtrain, eval=dtest)

        #check excution time
        ptm <- proc.time()

        bst = xgb.train(data = dtrain,watchlist = watchlist, params = params, nrounds = nround,verbose = 0, eta = mEta, gamma = mgamma, max_depth = mdepth)
        # print(repeatCount);print(proc.time() - ptm)

        #get importance from model.
        #------------------------------------------------------------------
        importance <- xgb.importance(feature_names = colnames(train),model=bst)
        #------------------------------------------------------------------

        #save epimarker's importance TOP20
        #------------------------------------------------------------------
        capture.output(print(bst$evaluation_log),file= paste0(resultPath,'evalLog_',mutationName,'_',topCount,'.txt'),append=TRUE)
        #------------------------------------------------------------------

        #saving the ordered epimarkers(rank)
        #------------------------------------------------------------------
        for(i in 1: nrow(importance)) {
          capture.output(cat(' ',importance$Feature[i]),file= paste0(resultPath,'rank_',mutationName,'_',topCount,'.txt'),append=TRUE)
          # capture.output(cat(' ',importance$Gain[i]),file= paste0(resultPath,'gain_',mutationName,'_',topCount,'.txt'),append=TRUE)

        }
        #------------------------------------------------------------------

        #new line
        capture.output(cat('\n'),file= paste0(resultPath,'rank_',mutationName,'_',topCount,'.txt'),append=TRUE)
        # capture.output(cat('\n'),file= paste0(resultPath,'gain_',mutationName,'_',topCount,'.txt'),append=TRUE)
      }
      #------------------------------------------------------------------

      #excute external .jar file.
      #------------------------------------------------------------------

      rankdf <- readFile(path = resultPath, top = topCount, mutation = colnames(mutation[mutaionIndex]), initJar = "f", bio_colnames = colnames(bio))
      writeFile(path = resultPath, top = topCount, mutation = colnames(mutation[mutaionIndex]), initJar = "f", rp = rp, nround = nround, rankdf = rankdf)

      #------------------------------------------------------------------
    }
    capture.output(cat(proc.time() - progSt),file= paste0(resultPath,'top1_time_',mutationName,'_',rp,'rp.txt'),append=TRUE)
  }
 # outlist <- list.files(resultPath,pattern = "output")
 # outlist <- outlist[-c(grep("extract",outlist))]
 # dirlist <- list.files(resultPath)[-c(which(list.files(resultPath) %in% outlist))]

#  for (i in dirlist){
#    file.remove(paste0(resultPath,i))
#  }

}
