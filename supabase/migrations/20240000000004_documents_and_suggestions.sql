-- Create Documents table
CREATE TABLE documents (
  id uuid PRIMARY KEY,
  content text,
  title text,
  user_id uuid REFERENCES auth.users(id),
  embedding vector(1536),  -- for ada-002 model
  -- or embedding vector(384) for text-embedding-3-small model
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- Create Suggestions table
CREATE TABLE IF NOT EXISTS public.suggestions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
    document_id UUID NOT NULL,
    document_created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    original_text TEXT NOT NULL,
    suggested_text TEXT NOT NULL,
    description TEXT,
    is_resolved BOOLEAN NOT NULL DEFAULT false,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()) NOT NULL,
    FOREIGN KEY (document_id, document_created_at) 
        REFERENCES public.documents(id, created_at) ON DELETE CASCADE
);

-- Enable RLS
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suggestions ENABLE ROW LEVEL SECURITY;