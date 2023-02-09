﻿namespace ix_draft_blazor
{
    public class Toast
    {
        public Guid Id = Guid.NewGuid();
        public string Type { get; set; } = "";
        public string Title { get; set; } = "";
        public string Message { get; set; } = "";
        public DateTimeOffset TimeToBurn { get; set; } = DateTimeOffset.Now.AddSeconds(30);
        public DateTimeOffset Posted = DateTimeOffset.Now;

        public Toast(string type, string title, string message, DateTimeOffset timeToBurn)
        {
            Type = type;
            Title = title;
            Message = message;
            TimeToBurn = timeToBurn;
        }
    }
}