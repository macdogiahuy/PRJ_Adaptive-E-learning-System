import os

import pyodbc
import requests
from fastapi import FastAPI
from fastapi.responses import JSONResponse
from pydantic import BaseModel

# ==============================================
# CONFIG
# ==============================================

# SQL Server connection
SQL_SERVER = os.getenv("AI_DB_SERVER", "mssql")
SQL_PORT = os.getenv("AI_DB_PORT", "1433")
SQL_NAME = os.getenv("AI_DB_NAME", "CourseHubDB")
SQL_USER = os.getenv("AI_DB_USER", "sa")
SQL_PASSWORD = os.getenv("AI_DB_PASSWORD", "ChangeMe123!")
SQL_ENCRYPT = os.getenv("AI_DB_ENCRYPT", "yes")
SQL_TRUST_CERT = os.getenv("AI_DB_TRUST_CERT", "yes")
SQL_DRIVER = os.getenv("AI_DB_DRIVER", "ODBC Driver 17 for SQL Server")

SQL_CONN = (
    f"DRIVER={{{SQL_DRIVER}}};"
    f"SERVER={SQL_SERVER},{SQL_PORT};"
    f"DATABASE={SQL_NAME};"
    f"UID={SQL_USER};"
    f"PWD={SQL_PASSWORD};"
    f"Encrypt={SQL_ENCRYPT};"
    f"TrustServerCertificate={SQL_TRUST_CERT};"
)
SQL_TIMEOUT = int(os.getenv("AI_DB_TIMEOUT", "15"))

# Cloud Ollama API
OLLAMA_URL = os.getenv("OLLAMA_URL", "https://ollama.com/api/chat")
OLLAMA_API_KEY = os.getenv("OLLAMA_API_KEY", "CHANGE_ME")
OLLAMA_TIMEOUT = int(os.getenv("OLLAMA_TIMEOUT", "30"))

# Cloud model
MODEL_NAME = os.getenv("OLLAMA_MODEL", "gpt-oss:120b-cloud")


# ==============================================
# FASTAPI INIT
# ==============================================

app = FastAPI()

class AdviceRequest(BaseModel):
    query: str


# ==============================================
# LOAD COURSE DATA
# ==============================================

def load_courses():
    conn = pyodbc.connect(SQL_CONN, timeout=SQL_TIMEOUT)
    cursor = conn.cursor()

    cursor.execute("""
        SELECT Id, Title, Description, Level, Outcomes,
               LearnerCount, TotalRating, RatingCount
        FROM Courses
        WHERE ApprovalStatus = 'APPROVED'
    """)

    data = [
        {
            "id": str(r.Id),
            "title": r.Title,
            "description": r.Description,
            "level": r.Level,
            "outcomes": r.Outcomes,
            "learners": r.LearnerCount,
            "totalRating": r.TotalRating,
            "ratingCount": r.RatingCount,
        }
        for r in cursor.fetchall()
    ]

    conn.close()
    return data


# ==============================================
# COURSE MATCHING / SCORING
# ==============================================

def score_course(course, query):
    score = 0
    q = query.lower()

    # content match
    for word in q.split():
        if word in course["title"].lower(): score += 2
        if word in course["description"].lower(): score += 1
        if word in course["outcomes"].lower(): score += 1

    # rating bonus
    if course["ratingCount"] > 0:
        score += (course["totalRating"] / course["ratingCount"]) / 5

    # learners bonus
    score += min(course["learners"] / 500, 2)

    return score


def select_best_courses(query, top_k=3):
    courses = load_courses()
    scored = sorted(courses, key=lambda c: score_course(c, query), reverse=True)
    return scored[:top_k]


# ==============================================
# CALL OLLAMA CLOUD API (🎯 CHUẨN)
# ==============================================

def call_ollama_cloud(prompt: str):
    headers = {
        "Authorization": f"Bearer {OLLAMA_API_KEY}",
        "Content-Type": "application/json"
    }

    payload = {
        "model": MODEL_NAME,
        "messages": [
            {"role": "user", "content": prompt}
        ],
        "stream": False
    }

    response = requests.post(OLLAMA_URL, json=payload, headers=headers, timeout=OLLAMA_TIMEOUT)
    response.raise_for_status()
    return response.json()["message"]["content"]


# ==============================================
# AI ADVISOR (TƯ VẤN KHÓA HỌC)
# ==============================================

def generate_advice(user_query: str):
    best = select_best_courses(user_query)

    course_text = "\n".join(
        f"- {c['title']} (Level: {c['level']}, Learners: {c['learners']})\n"
        f"  {c['description'][:80]}..."
        for c in best
    )

    prompt = f"""
Người dùng hỏi: "{user_query}"

Nhiệm vụ của bạn:
- Chỉ liệt kê các khóa học phù hợp nhất từ danh sách dưới đây.
- Mỗi khóa học phải có: 
    • Tên khóa học  
    • Lý do ngắn gọn tại sao khóa đó phù hợp (tối đa 2–3 dòng)  
- Không được viết lan man, không giới thiệu dài dòng.
- Trả kết quả rõ ràng, gọn gàng, dễ đọc.

Danh sách khóa học phù hợp:
{course_text}

Hãy trả lời theo đúng format:

📌 **Gợi ý khóa học**  
1. **Tên khóa học**  
   - Lý do: ...  
2. **Tên khóa học**  
   - Lý do: ...  
3. **Tên khóa học**  
   - Lý do: ...
"""

    return call_ollama_cloud(prompt)


# ==============================================
# FASTAPI ENDPOINT
# ==============================================

@app.post("/advice")
def advice(req: AdviceRequest):
    answer = generate_advice(req.query)
    return {
        "query": req.query,
        "advice": answer
    }


@app.get("/health")
def health():
    try:
        with pyodbc.connect(SQL_CONN, timeout=SQL_TIMEOUT) as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT 1")
            cursor.fetchone()
    except Exception as exc:
        return JSONResponse({"status": "degraded", "error": str(exc)}, status_code=503)

    return {"status": "ok"}

@app.get("/debug-key")
def debug_key():
    return {
        "env_key": os.getenv("OLLAMA_API_KEY"),
        "using_key": OLLAMA_API_KEY
    }

# ==============================================
# RUN:
# py -m uvicorn ollama_chatbox:app --reload
# ==============================================
