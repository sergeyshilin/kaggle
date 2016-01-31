import org.apache.lucene.demo.IndexFiles;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.search.ScoreDoc;

import java.io.IOException;
import java.util.ArrayList;

/**
 * Created by snape on 30.01.16.
 */
public class LuceneBenchmark {

    public static final String trainingSet = AllenLuceneUtils.allenHome +  "data/training_set.tsv";
    public static final String validationSet = AllenLuceneUtils.allenHome +  "data/validation_set.tsv";

    public static void main(String[] args) {
        AllenLuceneUtils utils = new AllenLuceneUtils();
        // utils.indexCorpus();

//        testUniqueQuestion(utils);
        ArrayList<String> predictions = utils.predictAnswer(validationSet, 10);
        utils.saveToCSV(AllenLuceneUtils.allenHome + "predictions_valid.csv", predictions);
    }

    private static void testUniqueQuestion(AllenLuceneUtils utils) {
        String question = "The site where nutrients, gas, and waste material are exchanged between \n" +
                "a mother and a developing fetus is/are the:";
        String questionsNew = question.replaceAll("[\\\\/\\^\"\\?\\*\\-\\[\\]\\(\\)_:\n,]", "");
        System.out.println(questionsNew);
        ScoreDoc[] topDocs = utils.getTopDocumentsOnQuery(questionsNew, 10);
        utils.printTopDocs(topDocs);

//        String answer = "1";
//        String answerNew = answer.replaceAll("[\\\\/\\^\"\\?\\*\\-\\[\\]\\(\\)_]", "");
//        System.out.println(answerNew);
//        try {
//            System.out.println("Score is " + utils.getWordSummaryScore(answerNew, topDocs));
//        } catch (ParseException e) {
//            e.printStackTrace();
//        }
    }
}
