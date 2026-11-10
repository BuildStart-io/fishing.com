function bytesToBase64(bytes: Uint8Array): string {
  let binary = "";
  for (let offset = 0; offset < bytes.length; offset += 8192) {
    binary += String.fromCharCode(...bytes.subarray(offset, offset + 8192));
  }
  return btoa(binary);
}

function resolveWahaUrl(rawUrl: string | undefined, wahaBase: string, sessionName: string, wahaMessageId: string): string {
  if (!rawUrl) {
    return `${wahaBase}/api/${encodeURIComponent(sessionName)}/messages/${encodeURIComponent(wahaMessageId)}/download`;
  }
  const trimmed = rawUrl.trim();
  if (trimmed.startsWith("/")) {
    return `${wahaBase}${trimmed}`;
  }
  try {
    const parsed = new URL(trimmed);
    if (parsed.hostname === "localhost" || parsed.hostname === "127.0.0.1") {
      const baseParsed = new URL(wahaBase);
      parsed.protocol = baseParsed.protocol;
      parsed.host = baseParsed.host;
      return parsed.toString();
    }
  } catch {
    // fallback to original trimmed url
  }
  return trimmed;
}

export async function transcribeAudio(
  sessionName: string,
  wahaMessageId: string,
  mediaUrl?: string,
  mimeTypeHint?: string
): Promise<string | null> {
  const WAHA_BASE = (Deno.env.get("WAHA_BASE_URL") || "").replace(/\/+$/, "");
  const WAHA_KEY = Deno.env.get("WAHA_API_KEY") || "";
  const OPENROUTER_API_KEY = Deno.env.get("OPENROUTER_API_KEY") || "";

  if (!OPENROUTER_API_KEY) {
    console.error("OPENROUTER_API_KEY is not configured.");
    return null;
  }

  // 1. Download WAHA Audio
  let audioBuffer: Uint8Array;
  let detectedMime = mimeTypeHint || "audio/ogg";

  try {
    const wahaUrl = resolveWahaUrl(mediaUrl, WAHA_BASE, sessionName, wahaMessageId);
    console.log(`Downloading audio from: ${wahaUrl}`);
    const res = await fetch(wahaUrl, {
      headers: { "X-Api-Key": WAHA_KEY, "Accept": "*/*" },
      signal: AbortSignal.timeout(15_000)
    });

    if (!res.ok) {
      console.error(`WAHA download failed (${res.status}): ${await res.text()}`);
      return null;
    }

    const contentType = res.headers.get("content-type");
    if (contentType && contentType.toLowerCase().includes("audio/")) {
      detectedMime = contentType.split(";")[0].trim();
    }

    audioBuffer = new Uint8Array(await res.arrayBuffer());
    console.log(`Downloaded ${audioBuffer.length} bytes of audio data (${detectedMime})`);
  } catch (err) {
    console.error("Error downloading audio from WAHA:", err);
    return null;
  }

  // 2. Convert to Base64
  const base64Audio = bytesToBase64(audioBuffer);

  // 3. Send to OpenRouter
  try {
    console.log("Sending to OpenRouter for transcription...");
    const orRes = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        models: ["google/gemini-2.5-flash", "google/gemini-2.5-flash-lite"],
        messages: [
          {
            role: "user",
            content: [
              {
                type: "text",
                text: "Transcribe this audio verbatim in its native language/script (Sinhala, Tamil, English, or Singlish). Do NOT translate or summarize. Output ONLY the transcription."
              },
              {
                type: "image_url",
                image_url: {
                  url: `data:${detectedMime};base64,${base64Audio}`
                }
              }
            ]
          }
        ]
      })
    });

    if (!orRes.ok) {
      console.error(`OpenRouter transcription failed (${orRes.status}): ${await orRes.text()}`);
      return null;
    }

    const orData = await orRes.json();
    const transcription = orData?.choices?.[0]?.message?.content?.trim();
    console.log("Transcription result:", transcription);
    return transcription || null;
  } catch (err) {
    console.error("Error transcribing audio:", err);
    return null;
  }
}
