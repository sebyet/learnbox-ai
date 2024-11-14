import { createClient } from '@/lib/supabase/server';
import { OpenAI } from 'openai';

const openai = new OpenAI();

export async function fetchRelevantDocs(query: string, userId: string) {
  const supabase = createClient();
  
  // Get embedding for the query
  const embedding = await openai.embeddings.create({
    model: "text-embedding-3-small",
    input: query,
  });

  const { data: documents, error } = await (await supabase)
    .rpc('match_documents', {
      query_embedding: embedding.data[0].embedding,
      match_threshold: 0.7,
      match_count: 5
    });

  if (error) {
    console.error('Error fetching relevant documents:', error);
    return [];
  }

  return documents.map((doc: { id: string; content: string; similarity: number; created_at: string }) => ({
    id: doc.id,
    content: doc.content,
    similarity: doc.similarity,
    created_at: doc.created_at
  }));
} 