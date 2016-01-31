import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.*;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.store.FSDirectory;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.Date;
import org.apache.commons.lang3.StringEscapeUtils;

/**
 * Created by snape on 30.01.16.
 */
public class AllenLuceneUtils {

    public static final String allenHome = "/home/snape/programming/python/kaggle/allen/";
    public static final String docsPath = allenHome + "data/wiki_data";
    public static final String indexPath =  allenHome + "data/Lucene_index";
    public static boolean  create = true;
    public FSDirectory indexDir = null;
    public IndexSearcher searcher = null;

    public AllenLuceneUtils() {
        try {
            indexDir = FSDirectory.open(Paths.get(indexPath, new String[0]));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void indexDocs(final IndexWriter writer, Path path) throws IOException {
        if(Files.isDirectory(path, new LinkOption[0])) {
            File dir = new File(path.toAbsolutePath().toString());
            File[] directoryListing = dir.listFiles();
            if (directoryListing != null) {
                for (File child : directoryListing) {
                    indexDoc(writer, child.toPath());
                }
            } else {
            }

        } else {
            indexDoc(writer, path);
        }

    }

    public void indexDoc(IndexWriter writer, Path file) throws IOException {
        InputStream stream = Files.newInputStream(file, new OpenOption[0]);
        Throwable var5 = null;

        try {
            Document x2 = new Document();
            StringField pathField = new StringField("path", file.toString(), Field.Store.YES);
            x2.add(pathField);
            x2.add(new TextField("contents", new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8))));
            if(writer.getConfig().getOpenMode() == IndexWriterConfig.OpenMode.CREATE) {
                System.out.println("adding " + file);
                writer.addDocument(x2);
            } else {
                System.out.println("updating " + file);
                writer.updateDocument(new Term("path", file.toString()), x2);
            }
        } catch (Throwable var15) {
            var5 = var15;
            throw var15;
        } finally {
            if(stream != null) {
                if(var5 != null) {
                    try {
                        stream.close();
                    } catch (Throwable var14) {
                        var5.addSuppressed(var14);
                    }
                } else {
                    stream.close();
                }
            }

        }

    }

    public void indexCorpus() {
        Path var13 = Paths.get(docsPath, new String[0]);
        if(!Files.isReadable(var13)) {
            System.out.println("Document directory \'" + var13.toAbsolutePath() + "\' does not exist or is not readable, please check the path");
            System.exit(1);
        }

        Date start = new Date();

        try {
            System.out.println("Indexing to directory \'" + indexPath + "\'...");
            StandardAnalyzer analyzer = new StandardAnalyzer();
            IndexWriterConfig iwc = new IndexWriterConfig(analyzer);

            if(create) {
                iwc.setOpenMode(IndexWriterConfig.OpenMode.CREATE);
            } else {
                iwc.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
            }

            IndexWriter writer = new IndexWriter(indexDir, iwc);
            indexDocs(writer, var13);
            System.out.println("Number of indexed documents:" + writer.numDocs());
            writer.close();
            Date end = new Date();
            System.out.println(end.getTime() - start.getTime() + " total milliseconds");
        } catch (IOException var12) {
            System.out.println(" caught a " + var12.getClass() + "\n with message: " + var12.getMessage());
        }
    }

    public ScoreDoc[] getTopDocumentsOnQuery(String query, int numberOfDocuments) {
        try {
            IndexReader reader = DirectoryReader.open(indexDir);
            searcher = new IndexSearcher(reader);
            StandardAnalyzer analyzer = new StandardAnalyzer();
            QueryParser parser = new QueryParser("contents", analyzer);
            Query q = parser.parse(query);
            TopDocs docs = searcher.search(q, numberOfDocuments);
            ScoreDoc[] filterScoreDosArray = docs.scoreDocs;

            return filterScoreDosArray;
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return null;
    }

    public void printTopDocs(ScoreDoc[] topDocs) {
        for (int i = 0; i < topDocs.length; ++i) {
            int docId = topDocs[i].doc;
            Document d = null;
            try {
                d = searcher.doc(docId);
            } catch (IOException e) {
                e.printStackTrace();
            }
            System.out.println((i + 1) + ". " + d.get("path")+" Score: "+ topDocs[i].score);
        }
    }

    public double getWordSummaryScore(String answer, ScoreDoc[] topDocs) throws ParseException {
        double score = 0;


        for(int i = 0; i < topDocs.length; ++i) {
            int docId = topDocs[i].doc;
            Document d = null;

            StandardAnalyzer analyzer = new StandardAnalyzer();
            QueryParser parser = new QueryParser("contents", analyzer);
            Query q = null;
            try {
                q = parser.parse(answer);
                score += searcher.explain(q, docId).getValue();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return score;
    }

    public ArrayList<String> predictAnswer(String datasetPath, int documentsNumber) {
        ArrayList<String> results = new ArrayList<>();
        String csvFile = datasetPath;
        BufferedReader br = null;
        String line = "";
        String cvsSplitBy = "\\t";

        try {

            br = new BufferedReader(new FileReader(csvFile));
            while ((line = br.readLine()) != null) {
                int maxAnswNumber = 0;
                double maxScore = 0;
                String[] lineParts = line.split(cvsSplitBy);
                String regex = "[\\\\/\\^\"\\?\\*\\-\\[\\]\\(\\)_:\n,]";
                ScoreDoc[] topDocs = getTopDocumentsOnQuery(lineParts[1].replaceAll(regex, ""), documentsNumber);
                int counterFrom = lineParts.length == 7 ? 3 : 2;
                String[] answers = {
                        lineParts[counterFrom].replaceAll(regex, ""),
                        lineParts[counterFrom + 1].replaceAll(regex, ""),
                        lineParts[counterFrom + 2].replaceAll(regex, ""),
                        lineParts[counterFrom + 3].replaceAll(regex, "")
                };

                for (int i = 0; i < answers.length; i++) {
                    double answerScore = getWordSummaryScore(answers[i], topDocs);
//                    System.out.print(answerScore + " ");
                    if(answerScore >= maxScore) {
                        maxScore = answerScore;
                        maxAnswNumber = i + 1;
                    }

                }

//                System.out.print("| " + maxAnswNumber);
                results.add(maxAnswNumber == 1 ? "A" :
                        maxAnswNumber == 2 ? "B" :
                        maxAnswNumber == 3 ? "C" :
                        maxAnswNumber == 4 ? "D" : "B");

//                System.out.print("\n");
                System.out.println("Processed question id: " + lineParts[0]);
            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            results.add("B");
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return results;
    }

    public void saveToCSV(String predictionsFilePath, ArrayList<String> predictions) {
        try {
            FileWriter writer = new FileWriter(predictionsFilePath);

            for (String pred : predictions) {
                writer.append(pred);
                writer.append('\n');
            }

            writer.flush();
            writer.close();
        } catch(IOException e) {
            e.printStackTrace();
        }
    }
}
